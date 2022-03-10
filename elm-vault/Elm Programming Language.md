# ELM Programming Language

# Talking Points

*Pros:*
- Functional language (FL) plus immutability promise high reliability and no bugs
- Virtual DOM concept promises high performance
- Simplest and easiest FL I have 
- Due to strict typing in addition to the above, it is impossible to do something wrong (it won't crash). Of course, as always it may not be what you want, but you cannot make coding mistakes.
- Extremely active and help community
- Nice package manager (equivalent to NPM)
- The tooling was very good and easy to use
- Nice architecture (clear and enforced lines between model and view)

*Cons:*
- If not familiar with functional languages, learning curve is high
- Few large companies using, as far as I could see
- Interoperability with JavaScript and React is tricky

*Experience this week:*
- I studied Elm about 20+ hours this week
	- Split between learning Elm itself and attempting to get Elm and React working together
	- The learning part went well (easier than React)
	- Interoperability was a failure: while I was able to get other people's stuff to work, I was unable to get something I had done to work... definitely need more time
- The Slack community was fantastic; one of the most active and helpful I have come across

*Things I did not get to:*
- How to deploy (altho this might be trivial, I did not get a chance to try anything)
- How to combine tailwind for styling

*Next steps:*
- Use for one-off tools and continue to learn
- Continue to look for integration opportunities into React

# Links

- Easy intro: https://elmprogramming.com/
- Installation on Linux: https://github.com/elm/compiler/blob/master/installers/linux/README.md
- VS Code syntax etc: https://github.com/elm-tooling/elm-language-client-vscode
- Online playground: https://elm-lang.org/try
- Slack: https://elmlang.slack.com
- Package Manager: https://package.elm-lang.org/
- Documentation: https://package.elm-lang.org/packages
- Youtube playlist: https://www.youtube.com/playlist?list=PL-cYi7I913S-VgTSUKWhrUkReM_vMNQxG
- The Elm Oracle: https://klaftertief.github.io/elm-search/
- How to use ELM and React: https://elm-lang.org/news/how-to-use-elm-at-work and https://www.npmjs.com/package/react-elm-components
- Some learning material: https://github.com/dwyl/learn-elm

# Objectives
1. What is elm like as a language? what can we learn from it?
2. How well supported is it? Is it risky?
3. Is it adequate to replace some/all of current tech stack?
4. Community support (see slack)

# Diary
![[Pasted image 20220225194944.png]]

## 2022-02-24

Looked at a lot of info on how to use elm inside react. Need to do this one next.
https://github.com/Parasrah/elm-react-component/tree/5ed27ab708a5edca07555acadbf2c0cb2cd8206a/example

## 2022-02-23

**Optimizing Elm Assets**
https://guide.elm-lang.org/optimization/asset_size.html
```elm
elm make src/Main.elm --optimize --output=elm.js
uglifyjs elm.js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output elm.min.js
```

**On Decoders:**
https://app.slack.com/client/T0CJ5UNHK/C192T0Q1E/thread/C192T0Q1E-1645573299.146689

Working thru filtered dropdown example in:
https://github.com/mandolyte/example-elm-searchable-dropdown

I have created a folder in the elm learning folder for this. I may track/mirror the steps there.

Things yet to learn:
- how to use tailwind css package with elm
- how to create a component in elm, publish to NPM, and then use in a react project
- how does WASM help, if at all


## 2022-02-22

**On forms** https://guide.elm-lang.org/architecture/forms.html
On how to begin a model:
I always start out by guessing at the Model. We know there are going to be three text fields, so let's just go with that:

type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  }
I usually try to start with a minimal model, maybe with just one field. I then attempt to write the view and update functions. That often reveals that I need to add more to my Model. Building the model gradually like this means I can have a working program through the development process. It may not have all the features yet, but it is getting there!

**HTML elements are functions!**
The neat thing about HTML in Elm is that input and div are just normal functions. They take (1) a list of attributes and (2) a list of child nodes. Since we are using normal Elm functions, we have the full power of Elm to help us build our views! We can refactor repetitive code out into customized helper functions. That is exactly what we are doing here!

So our view function has three calls to viewInput:
```elm
viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []
This means that writing viewInput "text" "Name" "Bill" Name in Elm would turn into an HTML value like <input type="text" placeholder="Name" value="Bill"> when shown on screen.
```

**Functions with multiple arguments**
Note: Functions that take multiple arguments end up having more and more arrows. For example, here is a function that takes two arguments:

```elm
> String.repeat
<function> : Int -> String -> String


>  
```
Giving two arguments like String.repeat 3 "ha" will produce "hahaha". It works to think of -> as a weird way to separate arguments, but I explain the real reasoning [here](https://guide.elm-lang.org/appendix/function_types.html). It is pretty neat! Namely:
	
	So conceptually, every function accepts one argument. It may return another function that accepts one argument. Etc. At some point it will stop returning functions.
	
Maybe
As you work more with Elm, you will start seeing the Maybe type quite frequently. It is defined like this:
```
type Maybe a
  = Just a
  | Nothing
```

Using:
```
> String.toFloat
<function> : String -> Maybe Float
> String.toFloat "3.14"
Just 3.14 : Maybe Float
> String.toFloat "hello"
Nothing : Maybe Float
```

- As the "type" of the function, String.toFloat returns the type "Maybe Float".
- When used, it returns the converted *value* or it returns "Nothing".

Thus:
```elm
String.toFloat "3.14"
-- returns Just 3.14
-- and 
String.toFloat "hello"
-- returns Nothing
-- then pattern matching can be done thusly:
view model =
  case String.toFloat model.input of
    Just celsius ->
      viewConverter model.input "blue" (String.fromFloat (celsius * 1.8 + 32))

    Nothing ->
      viewConverter model.input "red" "???"
```

**Managing and Installing packages**
There are tons of other packages on package.elm-lang.org though! So when you are making your own Elm programs locally, it will probably involve running some commands like this in the terminal:
```
elm init
elm install elm/http
elm install elm/random
```
That would set up an elm.json file with elm/http and elm/random as dependencies.




## 2022-02-21

Note: People coming from languages like JavaScript may be surprised that functions look different here:
```elm
madlib "cat" "ergonomic"                  -- Elm
madlib("cat", "ergonomic")                // JavaScript

madlib ("butter" ++ "fly") "metallic"      -- Elm
madlib("butter" + "fly", "metallic")       // JavaScript
```
A **function** using the elm repl tool:
```
> greet name =
|   "Hello " ++ name ++ "!"
| 
<function>

> greet "Bob"
"Hello Bob!"
```

**Lists**:
Lists can hold many values. Those values must all have the same type. Here are a few examples that use functions from the List module (https://package.elm-lang.org/packages/elm/core/latest/List)

**Tuples** are another useful data structure. A tuple can hold two or three values, and each value can have any type. A common use is if you need to return more than one value from a function. The following function gets a name and gives a message for the user:
```elm
> isGoodName name =
|   if String.length name <= 20 then
|     (True, "name accepted!")
|   else
|     (False, "name was too long; please limit it to 20 characters")
| 
<function>
```

A record (sort of like JSON) can hold many values, and each value is associated with a name.
Here is a record that represents British economist John A. Hobson:

> john =
|   { first = "John"
|   , last = "Hobson"
|   , age = 81
|   }
| 
{ age = 81, first = "John", last = "Hobson" }

> john.last
"Hobson"


It is often useful to update values in a record (note immutability, "john" is not actually updated; instead a new value is produced):
```
> john = { first = "John", last = "Hobson", age = 81 }
{ age = 81, first = "John", last = "Hobson" }

> { john | last = "Adams" }
{ age = 81, first = "John", last = "Adams" }

> { john | age = 22 }
{ age = 22, first = "John", last = "Hobson" }
```
Notice that when we update some fields of john we create a whole new record. It does not overwrite the existing one. Elm makes this efficient by sharing as much content as possible. If you update one of ten fields, the new record will share the nine unchanged values.

So a function to update ages might look like this:
```elm
> celebrateBirthday person =
|   { person | age = person.age + 1 }
| 
<function>

> john = { first = "John", last = "Hobson", age = 81 }
{ age = 81, first = "John", last = "Hobson" }

> celebrateBirthday john
{ age = 82, first = "John", last = "Hobson" }


>  
```


### Architecture
The basic pattern of an elm program is described here: 
https://guide.elm-lang.org/architecture/

What happens within the Elm program though? It always breaks into three parts:

- Model — the state of your application
- View — a way to turn your state into HTML
- Update — a way to update your state based on messages

These three concepts are the core of The Elm Architecture.



## 2022-02-18

1. Created repo: https://github.com/mandolyte/elm-programming-language
2. Linux install script tweaked and in the bin folder of preceding.
3. Version of Linux compiler:
```sh
$ elm --version
0.19.1
```
4. Installation page at: https://guide.elm-lang.org/install/elm.html. This has a number of examples of commands I should know.

