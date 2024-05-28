varibale "myvar" {
 type = string
 default = "hello terraform V"
}

varibale "mymap" {
 type = map(string)
 default = {
    mykey = "my key"
}


$terraform console
$var.myvar
$var.mymap["mykey"]
myvalue
$"${var.mymap["mykey"]}"
myvalue

varibale "mylist" {
 type = list
 default = [1,2,3]
}

$terraform console
var.mylist
[
1,
2,
3,
]
$var.mylist[0]
1
$element(var.mylist, 0)
1
$slice(var.mylist, 0, 2)
[
1,
2,
]


