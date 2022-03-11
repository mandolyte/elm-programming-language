# Notes on the book

## Chapter 1

Expressions are the building block of Elm applications.

Functions are reusable logic. They are not objects. They have no fields, no methods, and cannot store state. They have input parameters and evaluate to something.

A function body is simply an expression which evaluates to a value. Thus no "return" keyword is required in Elm.


On tuple deconsruction, page 27:
```elm
multiply2d someTuple = 
	let 
		(x,y) = someTuple -- deconstructs the var into a pair with names x and y
	in
		x * y
```

A module is a named collection of functions and other values.

How to update a record?
Here is a record and an update:
```
> x = {movie = "star wars", category = "scifi" }
{ category = "scifi", movie = "star wars" }
    : { category : String, movie : String }
> 
> y = { x  | category = "comedy", movie = "I love Lucy" }
{ category = "comedy", movie = "I love Lucy" }
    : { category : String, movie : String }
> y
{ category = "comedy", movie = "I love Lucy" }
    : { category : String, movie : String }
> x
{ category = "scifi", movie = "star wars" }
    : { category : String, movie : String }
> 
```

## Chapter 2

Consider this Elm code for HTML:
```
node "img" [src  "logo.png"] []

-- and compare this:

img [src "logo.png"] []
```
These are the same. In the second there is an `img` function imported from the Html module.

