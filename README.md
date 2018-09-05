##### Built-in timing curves

```
func blurAnimations(_ blurred: Bool) -> () -> Void {
    return {
      self.blurView.effect = blurred ? UIBlurEffect(style: .dark) : nil
      self.tableView.transform = blurred ? CGAffineTransform(scaleX: 0.75, y: 0.75) : .identity
      self.tableView.alpha = blurred ? 0.33 : 1.0
    }
  }
```

```
 func toggleBlur(_ blurred: Bool) {
    
    // 1. 测试1
//    UIViewPropertyAnimator.runningPropertyAnimator(
//      withDuration: 0.5, delay: 0.1, options: .curveEaseOut,
//      animations: {
//        self.blurView.alpha = blurred ? 1 : 0
//      },
//      completion: nil
//    )
    
    // 2. 测试2
    // AnimatorFactory.fade(view: blurView, visible: blurred)
    
    // 3. 测试3
    UIViewPropertyAnimator(duration: 0.55, curve: .easeOut,
                        animations:blurAnimations(blurred)).startAnimation()
    
    // 4. 测试4
    UIViewPropertyAnimator(duration: 0.55,
          controlPoint1: CGPoint(x: 0.57, y: -0.4),
          controlPoint2: CGPoint(x: 0.96, y: 0.87),
          animations: blurAnimations(blurred)).startAnimation()
  }
```

curve 参数类型为 UIViewAnimationCurve。 该枚举包括四种类型: .linear, .easeIn, .easeOut, and easeInOut。

模拟器上面效果不好，最好真机测试效果。

![](https://upload-images.jianshu.io/upload_images/130752-be376484bc288727.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### Custom Bézier curves

什么是 Bézier 曲线呢？

让我们看看一条直线。 它非常整洁，从点 A 开始到点 B 结束。

![](https://upload-images.jianshu.io/upload_images/130752-e12453e27e233609.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

能够如此精确地在屏幕上描述形状的便利方面是我们还可以对其应用变换：我们可以缩放、移动或者旋转它。一切都归功于坐标系中的这两点。 此外，我们还可以将 lines 保留到磁盘并将其加载回来，因为我们可以使用数字来描述它们，并且知道如何保留它。

而曲线比直线有趣多了，它可以绘制更多图样。eg. 

![](https://upload-images.jianshu.io/upload_images/130752-2c9ef3b4880c03ba.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

曲线不是随机的，它们也有一些像直线一样的特殊点，可以通过坐标来定义它们。

可以通过向线条添加控制点（control points）来定义曲线 ：

![](https://upload-images.jianshu.io/upload_images/130752-3b9e3f983e627a27.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们可以想象它是由铅笔绘制的连接到线的曲线，其起点沿着线 AC 移动，其终点沿着线 CB 移动：

![](https://upload-images.jianshu.io/upload_images/130752-bea3da20334f5d11.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

具有一个控制点的 Bézier 曲线称为二次曲线。 但是，我们对立方 Bézier 曲线会更感兴趣 - 那些曲线有两个控制点。

我们可以使用三次曲线来描述动画计时。 实际上，我们使用的内置曲线也是预先定义的三次曲线。

Core Animation 使用始终以坐标（0,0）开始的三次曲线，它代表动画持续时间的开始。 当然，这些时序曲线的终点始终是（1,1） -  动画的持续时间和进度的结束。

让我们来看看 ease-in curve ：

![](https://upload-images.jianshu.io/upload_images/130752-af9a6252b22b9c7b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

随着时间的推移（在坐标空间中从左向右水平移动），开始曲线在垂直轴上的进展非常小，然后大约在动画持续时间的一半时间后，进度加快并随着时间的推移而赶上，因此它们在动画结束时都达到了点（1,1）。

想更形象了解贝塞尔曲线，可以看看这个，[贝塞尔动画](https://www.jasondavies.com/animated-bezier/) 

想更多了解，请访问官网：[ http://cubic-bezier.com](http://cubic-bezier.com) 。

![](https://upload-images.jianshu.io/upload_images/130752-5b0bde02ffe5a459.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

弄清楚了贝塞尔曲线，PS 中钢笔工具的使用会更得心应手。

##### Spring Animations

方法 —UIViewPropertyAnimator(duration:dampingRatio:animations:) 可以定义 spring driven animations。

这将产生与调用 UIView 的（withDuration:delay:usingSpringWithDamping：initialSpringVelocity:options:animations:completion:) 方法相同的动画，动画初始速度为 0。

通过 UIViewPropertyAnimator(duration:timingParameters:) ，我们可以创建一个全新的对象，可以为动画提供计时数据，可以使用其中一个 UIKit 对象来定义自定义立方体或基于弹簧的时序（custom cubic or spring based timings）。

参数 timingParameters 是由 UIKit 定义的协议，UITimingCurveProvider 类型。 UIKit 中有两个符合该协议的类：UICubicTimingParameters  和 UISpringTimingParameters。

让我们来看看 UISpringTimingParameters ：

###### Providing damping and velocity

即使我们使用 custom timing provider ，我们仍然可以选择简单的方法，并提供阻尼比和初始速度（damping ratio and initial velocity），就像使用 convenience initializer 时一样。

```
let spring = UISpringTimingParameters(dampingRatio:0.5, initialVelocity: CGVector(dx: 1.0, dy: 0.2))
let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: spring)
```

初始速度是矢量类型。 如果要为视图的位置或大小设置动画，UIKit 将在开始时应用二维初始速度。 如果要为视图的位置设置 alpha 或单个轴（single axis）的动画，UIKit 将仅考虑初始速度矢量的 dx 属性。

initialVelocity 是一个可选参数，如果我们根本不需要设置速度，只需提供阻尼比（damping ratio）即可。

###### Custom springs

如果想更多的自定义弹簧的特性，可以在 UISpringTimingParameters 上使用不同的初始化器，指定弹簧的质量，刚度和阻尼等。

eg.

```
let spring = UISpringTimingParameters(mass: 10.0, stiffness: 5.0, damping: 30, initialVelocity: CGVector(dx: 1.0, dy: 0.2))
let animator = UIViewPropertyAnimator(duration: 1.0, t imingParameters: spring)
```
##### Auto Layout animations

Auto Layout animations 工厂方法
```
@discardableResult
  static func animateConstraint(view: UIView, constraint:
    NSLayoutConstraint, by: CGFloat) -> UIViewPropertyAnimator {
    let spring = UISpringTimingParameters(dampingRatio: 0.55)
    let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: spring)// 1.0
    animator.addAnimations {
      constraint.constant += by // 这里是 Auto Layout animations
      view.layoutIfNeeded()
    }
    return animator
  }
```
需要调用的地方直接调用方法调用即可。

```
AnimatorFactory.animateConstraint(view: view, constraint: dateTopConstraint, by: 100).startAnimation()
```


