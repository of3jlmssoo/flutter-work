![App Brewery Banner](https://github.com/londonappbrewery/Images/blob/master/AppBreweryBanner.png)

# Mi Card

## Our Goal

Now that you've seen how to create a Flutter app entirely from scratch, we're going to go further and learn more about how to design user interfaces for Flutter apps.

## What you will create

Mi Card is a personal business card. Imagine every time you wanted to give someone your contact details or your business card but you didn't have it on you. Well, now you can get them to download your business card as an app.

## What you will learn

* How to create Stateless Widgets
* What is the difference between hot reload and hot refresh and running an app from cold
* How to use Containers to lay out your UI
* How to use Columns and Rows to position your UI elements
* How to add custom fonts
* How to add Material icons
* How to style Text widgets
* How to read and use Flutter Documentation



>This is a companion project to The App Brewery's Complete Flutter Development Bootcamp, check out the full course at [www.appbrewery.co](https://www.appbrewery.co/)

![End Banner](https://github.com/londonappbrewery/Images/blob/master/readme-end-banner.png)

stless
to use the hot reload, stateless widget(Widget build()) is needed
hot reload
hot restart

container : takes the space as big as possible without any children
if child, take the space for the child

lesson 41 2023-07-30 
there is a safe area for the container. SafeArea
container's attribute, height, width, margin
for margin EdgeInsects
the margin is for the outside of your widget
the padding is for the inside of your widge
the container can only have one child

lesson 42
lots of children columns()  and rows()
mainAxisSize: MainAxisSize.min, 見た目変わらず。columnsのエリアが必要なだけになる
// mainAxisSize: MainAxisSize.min,
// verticalDirection: VerticalDirection.up,
組合せで順番変わったり、位置変わったり
画面の右端に揃えるのはトリッキー。widthがinfinityの4つ目のコンテナを作る
作らないと右揃えにはなるが画面の右端に行かない

crossAxisAlignment: CrossAxisAlignment.stretch,にすると強引に引き伸ばされる