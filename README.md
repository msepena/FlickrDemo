# FlickrDemo
Async loading of images in collection view cells based on the UICollectionViewDataSourcePrefetching protocol.

## Overview
App lazily load the images from Flickr site based on search query provided by the user. Instead of traditional way of pagination where user has to visit page by page, current design uses total image count from the first page request and provides the infinite scrolling.  

## Advantages
- User can scroll infinitly, no need to wait for page by page.
- Asyn loading of images based on the UICollectionViewDataSourcePrefetching protocol

## Key learnings from this project

- MMVM Design pattern
- Protocol oriented programming
- Lazy loading of images
- Best use of UICollectionViewDataSourcePrefetching protocol 
- Generic AsyncTash which will be used further
- Synchronized block execution
- KVO concepts


## Improvements to be done

- Network layer error handling
- Unit test cases 

## Requirement
- Xcode10




