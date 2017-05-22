//
//  JobsViewController.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 19/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import UIKit

class JobsViewController: BaseViewController {
    
    // Parameters.
    var didLoad: Bool = false
    
    // Class Instance.
    var job: GetJob {
       let job = GetJob()
        job.delegate = self
        return job
    }
    
    lazy var refreshController: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(getJobs), for: .valueChanged)
        return control
    }()
    
    // MARK: @IBOutlets.
    @IBOutlet weak var tableViewJobs: UITableView!

    override func viewDidLoad() { super.viewDidLoad(); onViewDidLoad() }
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated); onViewDidAppear() }
    
    func onViewDidLoad() {
        tableViewJobs.addSubview(refreshController)
    }
    
    func onViewDidAppear() {
        if didLoad { tableViewJobs.reloadData(); return }
        didLoad = true
        getJobs()
        indicator.start(onView: view)
    }
    
    func getJobs() {
        job.getJobs()
    }
}

extension JobsViewController: UITableViewDataSource, UITableViewDelegate, GetJobDelegate {
    
    func reload() {
        refreshController.endRefreshing()
        indicator.stop()
        tableViewJobs.reloadData()
    }
    
    func failed(withError error: String) {
        dropBanner(withString: error)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Job.jobs.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Job No. " + "#" + Job.jobs[section].ID
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobsTableViewCell") as! JobsTableViewCell
        let job = Job.jobs[indexPath.section]
        cell.set(withUrl: job.imageEp)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "JobViewController") as! JobViewController
        vc.job = Job.jobs[indexPath.section]
        navigationController?.pushViewController(vc, animated: true)
    }
}
