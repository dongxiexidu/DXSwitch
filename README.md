# DXSwitch
![image](https://github.com/dongxiexidu/DXSwitch/blob/master/demo.gif)
![image](https://github.com/dongxiexidu/DXSwitch/blob/master/xib_set.png)
  
# Feature
- [x] support Swift4
- [x] support xib/storybord
- [x] highlight effect
- [x] customizable
- [x] draggable
- [x] easy to use

# Usage
```
let mySwitch = DXSwitch.init(frame: CGRect.init(x: 200, y: 200, width: 80, height: 40))
mySwitch.valueChangeBlock = { value in
    print(value)
}
view.addSubview(mySwitch)
```

[LearnFrom: FlatUIKit](https://github.com/Grouper/FlatUIKit)
