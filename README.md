# BundleLoader
A simple library to help you load resources from bundle without changing your code.

我们知道，加载自定义bundle里的资源和加载mainBundle里的资源的代码是不同的。

BundleLoader帮你无缝地加载自定义bundle里的资源，而你无需修改已有的代码。这对于从App里拆分出Framework+bundle给第三方调用尤其有用。

Demo里已经测试了Framework加载bundle里xib，storyboard，图片，xcassets图片，普通文件资源的情况。其他常用的资源如Core Data模型，本地化资源等大家可以自行扩展和验证。

https://juejin.im/post/5ab8f9b4f265da23766b49cb
