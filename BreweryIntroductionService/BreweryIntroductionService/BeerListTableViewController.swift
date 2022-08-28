//
//  BeerListTableViewController.swift
//  BreweryIntroductionService
//
//  Created by 임윤휘 on 2022/08/25.
//

import UIKit

class BeerListTableViewController: UITableViewController {
    var beerList = [Beer]() //서버에서 받은 데이터를 저장할 배열
    //한번 불러온 데이터는 다시 불러오지 않도록
    var dataTasks = [URLSessionTask]()
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        //UITableView 설정
        tableView.prefetchDataSource = self
        tableView.register(BeerListTableViewCell.self, forCellReuseIdentifier: "BeerListTableViewCell")
        tableView.rowHeight = 150 //Delegate를 사용할 수도 있지만 이렇게 간단한 설정도 가능 고정 값
        
        //데이터 불러오기
        fetchBeer(of: currentPage)
    }
    
    //MARK: - Configure
    private func configureNavigationBar() {
        title = "브루어리"
        navigationController?.navigationBar.prefersLargeTitles = true //네비게이션바의 제목을 큰 스타일로 보여주기
        
    }
}

//UITableView DataSource, Delegate
extension BeerListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListTableViewCell", for: indexPath) as? BeerListTableViewCell else {return UITableViewCell()}
        
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let detailViewController = BeerDetailTableViewController()
        
        detailViewController.beer = selectedBeer
        self.navigationController?.pushViewController(detailViewController, animated: true)
        //self.show(detailViewController, sender: nil)
    }
}

//Prefetching
extension BeerListTableViewController: UITableViewDataSourcePrefetching {
    //현재 화면에서는 보이지 않지만 다음에 보여질 cell들에 대해서 미리 불러온다.
    //따라서 fetchBeer(of page: Int)에서 다음 page를 prefetch에 구현한다면 미리 불러올 수 있고, 그럼 스크롤을 내렸을때 계속 맥주가 있을 것이다.
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard currentPage != 1 else {return} //가장 처음에는 fetchBeer()에서 작업할 것이므로 메서드를 나간다.
        
        indexPaths.forEach{
            //현재 페이지와 동일할 때 다음 페이지 가져오기.
            //맥주 25씩 1 페이지. 따라서 25 배수
            if ($0.row + 1) / 25 + 1 == currentPage {//row는 0부터 시작이므로 +1 / 페이지 2부터 prefetch하니깐 +1
                self.fetchBeer(of: currentPage)
            }
        }
    }
}

//Data Fetching
private extension BeerListTableViewController {
    func fetchBeer(of page: Int) {
        //number값을 갖는 page파라미터를 사용
        //서버에서 페이지 단위(기본값, 한 페이지에 맥주 25개)로 맥주 리스트를 보내도록 설정
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
              dataTasks.firstIndex(where: {$0.originalRequest?.url == url}) //dataTask 목록 중 요청 url이 현재 url과 동일한 가장 첫번째 원소를 찾아 인덱스를 반환한다.
                == nil //firstIndex(where:)은 조건에 해당하는 원소가 없으면 nil을 반환하는데, 없다는건 해당 페이지를 처음 불러오는 것이므로 작업 이어서 수행
            else {return}
        
        var requst = URLRequest(url: url)
        requst.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: requst) { [weak self] data, response, error in
            guard error == nil,
                  let self = self,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
                print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                return
            }
            
            switch response.statusCode {
            case (200...299)://성공
                self.beerList += beers
                self.currentPage += 1
                
                /*
                 URLSession관련 코드는 내부적으로 이미 백그라운드에서 비동기적으로 수행되도록 설정되어있다. 그래서 우리가  DispatchQueue로 별도 설정하지 않아도 이미 메인 쓰레드가 아닌 별도의 스레드에서 작동하고 있다. 따라서 우리가 작성한 DataTask의 Completion에서 UI를 업데이트하는 부분은 반드시 메인 쓰레드에서 실행되도록 조정해주어야 한다.
                 */
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case (400...499)://클라이언트 에러
                print("""
                    ERROR: Client ERROR \(response.statusCode)
                    Response: \(response)
                """)
            case (500...599)://서버
                print("""
                    ERROR: Server ERROR \(response.statusCode)
                    Response: \(response)
                """)
            default:
                print("""
                    ERROR: ERROR \(response.statusCode)
                    Response: \(response)
                """)
            }
        }
        dataTask.resume() //실행
        dataTasks.append(dataTask) //지금 실행된 작업을 작업 목록에 추가하기
    }
}
