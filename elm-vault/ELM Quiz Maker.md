# Elm Quiz Maker

Working repo https://github.com/mandolyte/uw-quiz

## Links

- This one retrieves data via Http and is in v0.19.0 (needs to be v0.19.1):
https://github.com/kyledinh/elm-quiz

- This one is old, in v0.18.x: https://github.com/JordyMoos/elm-quiz/tree/4.0.0

- This one is also old: 
https://package.elm-lang.org/packages/camjc/elm-quiz/1.1.1/Quiz
It also points to an app that used it at:
https://github.com/camjc/nestle-or-not

## Ellie Links
Ellie working with a single question:
https://ellie-app.com/gPQJXSCd4cca1

Not working: https://ellie-app.com/gPS8B8q93p2a1
Not working: https://ellie-app.com/gPXmLqmnqKva1
Not working: https://ellie-app.com/gQ883pbrsvBa1

https://ellie-app.com/gQtJkTchJVYa1

```
> type UserId = UserId String
> x = UserId "whats up"
UserId ("whats up") : UserId
> type UserId = UserId String
> x = UserId "whats up"
UserId ("whats up") : UserId
> y = toString (UserId ) = idString
[1]+  Stopped                 elm repl
$ fg
elm repl

|   
-- UNEXPECTED EQUALS ------------------------------------------------------ REPL

I was not expecting to see this equals sign:

3| y = toString (UserId ) = idString
                          ^
Maybe you want == instead? To check if two values are equal?

Note: I may be getting confused by your indentation. I think I am still parsing
the `y` definition. Is this supposed to be part of a definition after that? If
so, the problem may be a bit before the equals sign. I need all definitions to
be indented exactly the same amount, so the problem may be that this new
definition has too many spaces in front of it.

> x
UserId ("whats up") : UserId
> toString (UserId idString) = idString
<function> : UserId -> String
> y = toString x
"whats up" : String
> 

```
Learning:
https://elm-radio.com/episode/primitive-obsession/
https://elm-radio.com/episode/intro-to-opaque-types/

```
> x = [ "a", "b", "c"]
["a","b","c"] : List String
> import List.Extra exposing (getAt)
> y = case getAt 0 x of
|   Nothing -> ""
|   Just char -> char
|   
"a" : String
> 
```
Update an element of a List:
https://package.elm-lang.org/packages/elm-community/list-extra/latest/List-Extra#updateIf




# Diary

## 2022-03-01

Step 1.
```
$ mkdir quiz
$ cd quiz
$ elm init
Hello! Elm projects always start with an elm.json file. I can create them!

Now you may be wondering, what will be in this file? How do I add Elm files to
my project? How do I see it in the browser? How will my code grow? Do I need
more directories? What about tests? Etc.

Check out <https://elm-lang.org/0.19.1/init> for all the answers!

Knowing all that, would you like me to create an elm.json file now? [Y/n]: Y
Okay, I created it. Now read that link!
$ 


$ elm install mdgriffith/elm-ui
Here is my plan:
  
  Add:
    mdgriffith/elm-ui    1.1.8

Would you like me to update your elm.json accordingly? [Y/n]: Y
Success!
$ 
```

Moved to https://github.com/mandolyte/uw-quiz

![[Pasted image 20220301105609.png]]

