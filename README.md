# Image Gallery
This project is an Images Gallery.

There are two main screens:
1. A grid (two columns in portrait, four columns in landscape) showing images obtained from a remote server. The user can tap on an image to see it in detail.
1. A detail screen when the user can see the full image at full resolution and zoom and pan over it. The user can share the image URL using native UI.

And two extra screens:
1. A native ActivityVC to share an image.
1. An error screen to show the errors (unathorized, no connection and unexpected).

## Run and Build
### 1. Install external dependencies
This project uses two external dependencies ([Alamofire](https://github.com/Alamofire/Alamofire)) and [SDWebImage](https://github.com/SDWebImage/SDWebImage)) through [Carthage](https://github.com/Carthage/Carthage)). 
1. Go to the folder containing the `.xcodeproj` (and the `Cartfile`).
2. Run `carthage update --platform iOS`.

### 2. Set the [Pexels](https://www.pexels.com/) API Key
1. You can obtain one from [here](https://www.pexels.com/api/new/))
2. You need to paste it on [./App/Config.xcconfig](https://github.com/llinardos/ImagesGallery/blob/master/App/Config.xcconfig)), as the value for the key `PEXELS_API_KEY`. E.g.: `PEXELS_API_KEY = 56...c9`.

### 3. Build and Run
1. Open the project with `Xcode`.
2. Select the `App` target.
3. Build and Run.

## Design & Technical details
1. I decided to use a modular architecture because:
	* Is a great way to define strong boundaries between components, promotes reusability and organization of work. There's not much about this topic online, maybe [this one](https://academy.realm.io/posts/justin-spahr-summers-library-oriented-programming/) is a great one, and [this other one too](https://github.com/tuist/microfeatures-guidelines) but with a coarser granularity. Though, the concepts of a demo for each module is a key one.
	* I can reuse some micro-libraries I've already developed (networking, layout, async, iOS helpers, etc.) and make me more productive.
2. In this case, there is one entire module for the `ImageGallery`. `ImageGallery` is divided internally in:
	* ImagesSource: the component who retains the images and loads more of them. There are two implementations, a mock one and a real one using [Pexel's API](https://www.pexels.com/api/). I've used Pexel [because 500px is not free anymore](https://support.500px.com/hc/en-us/articles/360002435653-API-). New images sources can be created at developer's need.
	* Gallery: A VC with a UICollectionView as main view and a special layout. It triggers the `loadMoreImages` on the `imageSource` and consumes its images, showing them as a two columns grid in portrait mode, or a four columns grid in landscape mode.
	* Detail: A zoomable and pannable image view in another VC. The user can share the image using native mechanisms. The usar can also tap two times to reset the zoom level.
3. Inside `ImageGallery`, I decided to keep it simple and use the standard iOS MVC. Mainly given the reduced scope and the strong boundary defined by the module. 
4. `ImageGallery` module exposes the class `ImageGallery`. This public class works as a entry point and coordinates the image gallery, the detail and the share. It can be seen as the [popular "coordinator"](http://khanlou.com/2015/01/the-coordinator/), but with a more meaningful and business related name. Also, given the scope and size of each submodule inside the module, there's no need to have a "coordinator"/"controller" by each VC. It's enough with the `App` object. This is another advantage of work in a modular way, you can work with the "pattern" that better fits in each module.
4. The public API of the `ImageGallery` is an `init` which receives a `ImagesSource` and a `run` which receive the window in which run. 
5. The Module `App` is the only one module/target which is an `Application`, it instantiates an `PexelsImagesSource` with an API key, setups the `ImageGallery` and `run`s it.
6. Tests and demos can be added using the `ImageGallery` module, but I run out of time.



