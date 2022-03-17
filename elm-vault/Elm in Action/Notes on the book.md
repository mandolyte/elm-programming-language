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

Definition: Partially applying a function means passing it some of its arguments - but not all of them - and getting back a new function that will accept the remaining arguments and finish the job.

Definition: *A curried function* is a function that can be partially applied. **All Elm functions** are curried!

Definition: *A message* is a value used to pass information from one part of the system to another.

The Browser.sandbox function takes a record with three fields:
- model: a value, name of the application model variable; this is the initial state of the application
- view: a function that takes a model and returns an Html node (and its children)
- update: a function that takes a message and a model, and returns a new model

Example `main` using the sandbox function:
```elm
main = 
  Browser.sandbox
    { init = initialModel
    , view = view
    , update = update
    }
```

Example update function:
```elm
update msg model = 
  if msg.description == "ClickedPhoto" then 
    { model | selectedUrl = msg.data }
  else 
    model
```

## Chapter 3 "Compiler as assistant"

Definition: a *type variable* represents more than one possible type. Type variables have lowercase names, making them easy to differentiate from *concrete types* like String, which are always capitalized.

In a type annotation like this:
```elm
fromList : List elementType -> Array elementType
```

The variable `elementType` is a "type variable". They can have any name and simple letters are often used. So this is equivalent:
```elm
fromList : List a -> Array a
```

There are three reserved type variable names: number, appendable, and comparable.

Definition: a *type alias* assigns a name to a type. Anywhere you would refer to that type, you can substitute this name instead.

Example:
```elm
type alias Photo = 
	{ url : String }
```

This is an interesting progression showing how curried functions work:
```
> String.padLeft
<function> : Int -> Char -> String -> String
> String.padLeft 9
<function> : Char -> String -> String
> String.padLeft 9 '.'
<function> : String -> String
> String.padLeft 9 '.' "not!"
".....not!" : String
> 
```

On p. 62 there is a discussion on Html's type variable. It says that Html has a type variable argument, just like List has them.

So `List String`, which is the type of `[ "foo", "bar" ]` and so is a list of String elements.

So also these:
```elm
div [ onClick "foo" ] []
div [ onClick 3.14 ] []
div [ onClick {x = 3.3 } ] []
```
are  of types: "Html String", "Html Float", and "Html  {x:Float}", respectively.

So when I see an app doing this:
```elm
type alias Msg =
	{ description : String, data : String }
-- followed by...
view : Model -> Html Msg
```
Then the view function is taking a Model as an input parameter and outputting an Html with Msg as the output type.

To enumerate all the possible "messages" that might come from the HTML, Elm allows the types to be a union of types.

Definition: A *command* is a value that describes an operation for the Elm Runtime to perform. Unlike calling  a function, running the same command multiple time can have different results.

NOTE: at chapter end, PhotoGroove9.elm is the final version of the code. Described in Summary on p. 84 and listed with notes in Listing 3.7 on p. 85.


## Chapter 4 "Talking to Servers"

The "<|" operator...

These two lines do the same thing:
```elm
> String.toUpper (String.reverse "hello")
"OLLEH" : String
> String.toUpper <| String.reverse "hello"
"OLLEH" : String
> 
```

The "arrow" points to the direction of the data. Here the data flows right to left (same as when the first expression that uses parentheses).

To pipe the data left to right use this form:
```elm
> String.reverse "hello" |> String.toUpper
"OLLEH" : String
> 
```

The placeholder character is an underscore... same as Go.
 
 The "::" operator removes the first element from a list. So does List.head:
 ```elm
 > a1 = [1,2,3,4]
[1,2,3,4] : List number
> List.head a1
Just 1 : Maybe number
> List.tail a1
Just [2,3,4] : Maybe (List number)
> case List.head a1 of
|   Just a -> a
|   Nothing -> 0
|   
1 : number
> 
```

Definition: an *effect* is an operation that modifies external state. A function that modifies external state when it executes has a *side effect*.

On Http.get: it is a function that returns a Cmd representing the HTTP request we want to make. Here is its type:

```elm
Http.get : { url : String, expect : Expect msg } -> Cmd msg
```

Once the command completes, it will send a message (Msg) to `update` telling us what happened (p. 101).

In turn, that "Expect msg" is Http.expectString toMsg.

So this:
```elm
Http.get { url = "http://manning.com", expect = Http.expectString toMsg }
```
goes like this:
- send the get request using the url
- tell Http that we expect to get back as a response a value that is a "string", technically, an "expectString". Also allowed are "expectJson", "expectBytes", and "expectWhatever".
- When it does return a string, process it with toMsg to transform it into a message for the update function.
- Finally, send that message to the update function

An expectString has this type:
```elm
type Result errValue okValue
	= Err errValue
	| Ok okValue
```

Thus if an error is returned, we get the errValue and if the string is returned it is the okValue.

*Destructuring tuples and records* see tip on page 106.

**Section 4.3** Decoding Json

Install it: `elm install elm/json`

*The decodeString function*: this will decode a string of JSON.
Returns a `Result`

Type:
```elm
decodeString : Decoder val -> String -> Result Error val
```
So it takes a "decoder" and a JSON string and returns a result.

Examples from repl:
```
> import Json.Decode exposing (Decoder, list, bool, string, int, field)

> decodeString bool "42"
Err (Failure ("Expecting a BOOL") <internals>)
    : Result Error Bool
> decodeString bool "false"
Ok False : Result Error Bool
> 
-- "bool" is a decoder (see import list of others)

-- let's write my own decoder based on the field function
-- the field function takes two arguments:
-- a field name: here hardcoded as "email"
-- a json string

decoder = 
    field "email" string

-- here is a json string with backslashes to escape the internal quotes

jstring = "{\"email\": \"cat@wolf.com\"}"


> decodeString decoder jstring
Ok "cat@wolf.com" : Result Error String


```



