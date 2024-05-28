# Linux Cheatsheet 

1. [ Find ](#find)
2. [ VI Editor ](#vieditor)

<a name="find"></a>
## FIND
### Find files larger than given size (gb/mb/kb/bytes) 
```
find / -type f -size +100M -exec ls -lh {} \; | awk '{ print $9 "|| Size : " $5 }'
```

---

<a name="vieditor"></a>
## VI EDITOR  
## VI Editor Shortcuts 

***
| S.No. | Link |
|:-----|:------:|
| **vi filename** |  Open or edit a file |  
| **i** | Switch to Insert mode  |  
| **G** |  Go to the last line in a file |  
| **XG** | Go to line X in a file.  |  
| **gg** |  Go to the first line in a file. |  
| **Esc** | Switch to Command mode.  |  
| **:w** |  Save and continue editing. |  
| **:wq** | Save and quit/exit vi.  |  
| **:q!** |  Quit vi and do not save changes. |  
| **dd** |  Delete an entire line. |  
| **Xdd** |  Delete X number of lines. |  
| **:num** | Display the current line’s line number.  |  
|  |   |  
|  |   |  
|  |   |  
|  |   |  
|  |   |  

***

yy — Yank (copy) a line of text.   
p — Paste a line of yanked text below the current line.  
o — Open a new line under the current line.  
O — Open a new line above the current line.  
A — Append to the end of the line.  
a — Append after the cursor’s current position.  
I — Insert text at the beginning of the current line.  
b — Go to the beginning of the word.  
e — Go to the end of the word.  
x — Delete a single character.  
Xyy — Yank X number of lines.  
h — Move left one character.  
j — Move down one line.   
k — Move up one line.  
l — Move right one character. 
