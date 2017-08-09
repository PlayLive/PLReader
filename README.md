![PLReader](https://github.com/PlayLive/PLReader/PLReader.png)

[![License](http://img.shields.io/badge/License-MIT-green.svg?style=flat)](https://github.com/PlayLive/PLReader/LICENSE)
[![Swift 3](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://swift.org)
[![WeiBo: @放飞吧小熊](http://weibo.com/ioslive)

PLReader can split text into multiple pages and provide a good reading experience written in Swift.

-[Features](#features)
-[Requirements](#requirements)
-[Usage](#usage)
-[Credits](#credits)
-[License](#license)

## Features

- [x] The text quick page, easy to read
- [x] Performance is good，Need less memory, Just two ViewController rendering

## Requirements

- iOS 9.0+
- Xcode 8.0+
- Swift 3.0+

## Usage

- Inherit PLReaderViewController

```swift
import UIKit

class ViewController: PLReaderViewController {

}

```

- Override PLReaderPageViewControllerDelegate method. When turn page, these method will be invoked.

```swift

    override func requestNext(chapterID: String) {

    }

    override func requestPrev(chapterID: String) {

    }

    override func changePageComplete(chapterID: String) {

    }
}

```

- Add section data call addChapter method, the following example data add prepared.

```swift
let ChapterID_One: String = "Chapter1"
let ChapterID_Two: String = "Chapter2"

addChapter(resourcesName: ChapterID_One, resourcesChapterID: ChapterID_One, currentChapterID: ChapterID_One, prevChapterID: ChapterID_One, nextChapterID: ChapterID_Two, postionType: ChapterPostionType.current)

addChapter(resourcesName: ChapterID_Two, resourcesChapterID: ChapterID_Two, currentChapterID: ChapterID_One, prevChapterID: ChapterID_One, nextChapterID: ChapterID_Two, postionType: ChapterPostionType.next)


func addChapter(resourcesName: String, resourcesChapterID: String, currentChapterID: String, prevChapterID: String, nextChapterID: String, postionType: ChapterPostionType) {
        let text: String? = try? String(contentsOfFile: Bundle.main.path(forResource: resourcesName, ofType: "txt")!, encoding: String.Encoding.utf8)
        if text != nil {
            let chapterModel = addChapter(text: text!, chapterID: resourcesChapterID, currentChapterID: currentChapterID, type: postionType)
            chapterModel?.prevChapterID = prevChapterID
            chapterModel?.nextChapterID = nextChapterID
        }
    }

```

- when add data complete call show method, you will see the following
