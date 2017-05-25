//
//  HomeViewController.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 23/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import Koloda
import UIKit

class HomeViewController: BaseViewController {
    
    // @IBOutlets.
    @IBOutlet weak var viewKoloda: KolodaView!
    
    // Parameters.
    var didLoad: Bool = false
    
    // Class Instances.
    
    var viewJob: JobView {
        let view = Bundle.main.loadNibNamed("JobView", owner: self, options: nil)?.first as! JobView
        return view
    }
    
    var job: GetJob {
        let job = GetJob()
        job.delegate = self
        return job
    }
    
    lazy var updateJob: UpdateJob = {
        let update = UpdateJob()
        update.delegate = self
        return update
    }()

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
        _ = (error == "Job already completed." || error == "Job not found,") ?
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
        view.job = Job.jobs[index]
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
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        direction == .left ? swipedLeft(jobAtIndex: index) : swipedRight(jobAtIndex: index)
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.resetCurrentCardIndex()
    }
}

// Swiped Right.
extension HomeViewController {
    
    func swipedRight(jobAtIndex index: Int) {
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
}

// Swiped Left.
extension HomeViewController: EditDelegate, UpdateJobDelegate {
    
    func swipedLeft(jobAtIndex index: Int) {
        editJob(atIndex: index)
    }
    
    func editJob(atIndex index: Int) {
        guard Job.jobs.indices.contains(index) else { dropBanner(withString: "Invalid job."); return }
        let view = EditJobView(frame: self.view.bounds, job: Job.jobs[index])
        view.delegate = self
        self.view.addSubview(view)
        navigationController?.setNavigationBarHidden(true, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            view.viewJob.textFieldName.becomeFirstResponder()
        }
    }
    
    func update(job: Job.Job) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        indicator.start(onView: view)
        updateJob.updateJob(job: job)
    }
    
    func cancelled() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func updated(jobWithID ID: String) {
        // Remove the updated job.
        Job.deleteJob(byID: ID)
        reload()
    }
}
