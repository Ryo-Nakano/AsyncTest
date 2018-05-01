//
//  ViewController.swift
//  AsyncTest
//
//  Created by Ryohei Nanano on 2018/05/01.
//  Copyright © 2018年 GeekSalon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        asyncTest3()
    }

   
    
    //これだと全部の処理が終わる前に完了のprint分呼ばれちゃう...
    func asyncTest1() {
        let group = DispatchGroup()
        
        group.enter()//enterで非同期処理開始みたいなもん？
        DispatchQueue.global(qos: .default).async {//この中に書かれた処理が非同期で同時に処理されるのかな？
            self.hoge(n: 3, label: 1)
        }
        DispatchQueue.global(qos: .default).async {//この中に書かれた処理が非同期で同時に処理されるのかな？
            self.hoge(n: 5, label: 2)
        }
        DispatchQueue.global(qos: .default).async {//この中に書かれた処理が非同期で同時に処理されるのかな？
            self.hoge(n: 4, label: 3)
        }
        group.leave()//終わった事を外(?)に対して知らせているイメージかな？
        
        group.notify(queue: DispatchQueue.global(qos: .default)) {//leaveが確認できたら処理開始！(引数の中ではどのスレッドで処理するかを指定してるのかな？)
            print("すべてのキューの処理が完了しました")
        }
    }
    
    //これだと結局直列的に処理されちゃう...
    func asyncTest2() {
        let group = DispatchGroup()
        
        group.enter()//enterで非同期処理開始みたいなもん？
        DispatchQueue.global(qos: .default).async {//この中に書かれた処理が非同期で同時に処理されるのかな？
            self.hoge(n: 3, label: 1)
            self.hoge(n: 5, label: 2)
            self.hoge(n: 4, label: 3)
            group.leave()//終わった事を外(?)に対して知らせているイメージかな？
        }
        
        group.notify(queue: DispatchQueue.global(qos: .default)) {//leaveが確認できたら処理開始！(引数の中ではどのスレッドで処理するかを指定してるのかな？)
            print("すべてのキューの処理が完了しました")
        }
    }
    
    //▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼これが正しい実装▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
    func asyncTest3() {
        let group = DispatchGroup()//DispatchGroupをインスタンス化
        
        DispatchQueue.global(qos: .default).async(group: group) {//非同期処理をgroupに紐付け！
            self.hoge(n: 3, label: 1)
        }
        DispatchQueue.global(qos: .default).async(group: group) {//非同期処理をgroupに紐付け！
            self.hoge(n: 5, label: 2)
        }
        DispatchQueue.global(qos: .default).async(group: group) {//非同期処理をgroupに紐付け！
            self.hoge(n: 4, label: 3)
        }
        
        group.notify(queue: DispatchQueue.global(qos: .default)) {//group内の全ての処理が終わったらこの中の処理が呼ばれる！
            print("すべてのキューの処理が完了しました")
        }
    }
    //▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲これが正しい実装▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
    
    
    //無碍にn秒間待つ関数
    func hoge(n: Int, label: Int)//n秒待つ、labelで見分け
    {
        for i in 0...n {
            print(i)//iの値をコンソール出力
            sleep(1)//1s待つ
        }
        print("Completed " + String(label) + " work!!")
    }


}

