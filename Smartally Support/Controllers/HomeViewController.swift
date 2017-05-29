//
//  HomeViewController.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 23/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import Koloda
import UIKit

class HomeViewController: BaseViewController, JobViewDelegate {
    
    // @IBOutlets.
    @IBOutlet weak var viewKoloda: KolodaView!
    
    // Parameters.
    var didLoad: Bool = false
    
    // Class Instances.
    var viewJob: JobView {
        let view = Bundle.main.loadNibNamed("JobView", owner: self, options: nil)?.first as! JobView
        view.delegate = self
        return view
    }
    
    var job: GetJob {
        let job = GetJob()
        job.delegate = self
        return job
    }
    
    var updateJob: UpdateJob {
        let update = UpdateJob()
        update.delegate = self
        return update
    }

    // Lifecycle.
    override func viewDidLoad() { super.viewDidLoad(); onViewDidLoad() }
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated); onViewDidAppear() }
    
    func onViewDidLoad() {
        // Koloda preferences.
        viewKoloda.dataSource = self
        viewKoloda.delegate = self
        // Navigation Bar preferences.
        let reloadButton = UIBarButtonItem(title: "More Jobs", style: .plain, target: self, action: #selector(getJobs))
        navigationItem.rightBarButtonItem = reloadButton
    }
    
    func onViewDidAppear() {
        if didLoad { reload(); return }
        didLoad = true
        getJobs()
    }
    
    func getJobs() {
        indicator.start(onView: view)
        job.getJobs()
    }
}

extension HomeViewController: GetJobDelegate {
    
    func reload() {
        indicator.stop()
        viewKoloda.resetCurrentCardIndex()
    }
    
    func failed(withError error: String) {
        indicator.stop()
        dropBanner(withString: error)
        _ = (error == "Job already completed." || error == "Job not found.") ?
            getJobs() :
            viewKoloda.revertAction()
    }
}

// DataSource:
extension HomeViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return Job.jobs.isEmpty ? 1 : Job.jobs.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        if Job.jobs.isEmpty {
            let imageView = UIImageView(image: UIImage(named: "no_data"))
            imageView.contentMode = .center
            return imageView
        }
        
        let view = viewJob
        view.tag = index
        return view
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return nil
    }
}

// Delegate:
extension HomeViewController: KolodaViewDelegate {
    
    func koloda(_ koloda: KolodaView, shouldDragCardAt index: Int) -> Bool {
        return !Job.jobs.isEmpty
    }
    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        return direction == .right
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        swiped(jobAtIndex: index)
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.resetCurrentCardIndex()
    }
}

// Swiped Right.
extension HomeViewController: UpdateJobDelegate {
    
    func swiped(jobAtIndex index: Int) {
        guard Job.jobs.indices.contains(index) else { dropBanner(withString: "Invalid job."); return }
        do
        {
            try Validator.validate(job: Job.jobs[index])
            update(job: Job.jobs[index])
        }
        catch Validator.Err.name {
            dropBanner(withString: "Can't update job with blank merchant name.")
            // Bring back the table.
            viewKoloda.revertAction()
        }
        catch Validator.Err.amount {
            dropBanner(withString: "Can't update job with blank amount.")
            // Bring back the table.
            viewKoloda.revertAction()
        }
        catch {} // Nope, never ever!
    }
    
    func update(job: Job.Job) {
        indicator.start(onView: view)
        updateJob.updateJob(job: job)
    }
    
    func updated(jobWithID ID: String) {
        // Remove the updated job.
        Job.deleteJob(byID: ID)
        reload()
    }
}
