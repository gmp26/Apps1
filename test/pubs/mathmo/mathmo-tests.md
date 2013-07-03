# Mathmo tests

## Notes

When you're populating `testlist` with questions and answers, remember to escape backslashes (`\\`) and quote marks (`\"`) correctly. I'm using a [TextExpander][te] snippet to escape these automatically. I have the following AppleScript:

    on findAndReplace(tofind, toreplace, TheString)
        set ditd to text item delimiters
        set text item delimiters to tofind
        set textItems to text items of TheString
        set text item delimiters to toreplace
        if (class of TheString is string) then
            set res to textItems as string
        else -- if (class of TheString is Unicode text) then
            set res to textItems as Unicode text
        end if
        set text item delimiters to ditd
        return res
    end findAndReplace
    
    set s to findAndReplace("\\", "\\\\", the clipboard)
    set t to findAndReplace("\"", "\\\"", s)
    
    return t

bound to `;ls` (for LiveScript, even though the test file is CoffeeScript) to do this automatically. Yes, even if AppleScript is awful for text manipulation. At the core of this project is JavaScript, so we're in no position to judge.

Notes on `problems.js`:

* Use `\DeclareMathOperator*` (or even a global stylesheet) rather then `{\rm artanh}` where appropriate.
* Fix `\,\mathrm{d}x` for integrals
* <strikethrough>Use an `align*` environment for Newton-Raphson (and possibly a `\phantom{-}` if we can manage it)</strikethrough>
* Give the `<ul>`'s used in the exercises their own class in CSS, then the formatting can be consistent and global. (And use a list in some of the answers where it isn’t already.)
* Fix `makeMatXforms`
* Add non-breaking spaces in the `3 DP.`
* Explore use of `\left(` and `\right)` delimiters.

[te]: http://smilesoftware.com/TextExpander/index.html
