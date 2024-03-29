今天插入一期广告，介绍为什么要使用Julia语言。研究传染病模型的编程语言我个人见到最多的是Python,R,Matlab,Julia。 Python和R语言用的偏多，比如帝国理工团队很多就用R语言。那为什么要选择Julia语言呢？网上一搜，有很多专业的答案，比如，和Python一样好用，和C++一样快，集合了Matlab和R的优点。我从生物数学方向的角度试着回答这个问题。

最开始我使用的是Matlab，但自从Python火了，Matlab在某些高校被封之后，为了蹭热度，我就去学了Python，发现，真香，由衷的感叹，It is totally what I want! 
Python的优点是成熟，火，开源，社区强大，帮助文档多，是解释性的胶水语言。Python是机器学习深度学习大本营，很多机器学习模型几条命令就能实现，个人认为是能最快上手的语言，也是必须得学的语言。很长一段时间，Python是我科研的主要语言。配合R语言数据处理和可视化，可以很好地完成我的任务。直到有一天，我碰到一个问题：用particle MCMC方法对传染病模型参数进行贝叶斯推断。我试了Python的一些库，试了R语言的库。 所看的文献有开源的程序，README写着：

- 运行Run文件，7-10天程序结果就出来了，取决于你的电脑配置

当时我就给大佬跪了，7-10天，我又没服务器。Python和R运行速度是真心慢，也有快的方法，往往需要Linux系统，或者windows上进行一大堆复杂的配置。知道一次偶然的机会，适了一下Julia，我又发现，It is totally what I want! 


对于我们大部分人，我们只需要知道Julia好用并且快就行。为什么对于我们学生物数学的来说，Julia好用呢？因为Julia就是学数学，学微分方程，学统计这一帮子人开发的，Julia是MIT整个学校一起贡献的语言，也是MIT数学系上课用的语言。用了Julia语言就会发现，它非常符合我们学数学的人的思维。比如函数的定义
```julia
f = x -> x^2 + 2x - 1
```
偏微分方程的定义
```julia
@parameters x y
@variables u(..)
Dxx = Differential(x)^2
Dyy = Differential(y)^2

# 2D PDE
eq  = Dxx(u(x,y)) + Dyy(u(x,y)) ~ -sin(pi*x)*sin(pi*y)

# Boundary conditions
bcs = [u(0,y) ~ 0.0, u(1,y) ~ -sin(pi*1)*sin(pi*y),
       u(x,0) ~ 0.0, u(x,1) ~ -sin(pi*x)*sin(pi*1)]
# Space and time domains
domains = [x ∈ Interval(0.0,1.0),
           y ∈ Interval(0.0,1.0)]
```
随处可见的想我们所想。包括微分方程参数的贝叶斯推断，Python和R中写很长很长的代码，Julia几行代码就行。


Julia语言另一个优点，快。和python不同，它是编译型语言。简单讲就是，把电脑当成是打工人，编程语言是老板。对于很多编程语言，老板派活了，打工人得先了解这些活是什么，老板到底是什么意思，等明白啥意思了，才能开始干活。但Julia这个老板清楚地知道打工人干活的细节，并且会优化指导打工人需要做的事情。Julia之所以快，是因为它的类型系统(Python中对象)以及多重分派(Python中方法)。 比如我们要定义“运算:加减乘除”。对于Python，会定义实数对象以及实数的加减乘除，复数对象复数的加减乘除，群对象群加减，环对象环的运算，域对象域的运算。
Julia的类型系统和多重分派是这样做的， 定义类型，实数，复数，群，环，域。 定义对象加法，减法，乘法，除法。 定义不同类型下的加法，减法，乘法，除法。 简单的理解就是python中的对象和方法分离。