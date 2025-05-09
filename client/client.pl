\:- use\_module(library(socket)).
\:- use\_module(library(http/json)).

connect\_to\_server :-
tcp\_connect(localhost:12345, Stream, \[type(text)]),
set\_stream(Stream, encoding(utf8)),

```
choose_role(Stream, _Role),
format('Connected. Use WASD to move, Q to quit~n~n', []),
client_loop(Stream).
```

choose\_role(Stream, Role) :-
format('Choose your role:~~n1 - Victim~~n2 - Maniac\~n', \[]),
get\_single\_char(Input),
(   Input =:= 0'1 -> Role = victim
;   Input =:= 0'2 -> Role = maniac
;   format('Invalid choice. Defaulting to victim.\~n', \[]), Role = victim
),
format(Stream, '~~w~~n', \[Role]),
flush\_output(Stream).

display\_map(JsonString) :-
open\_string(JsonString, Stream),
json\_read\_dict(Stream, JsonTerm, \[value\_string\_as(atom)]),
close(Stream),
(   is\_dict(JsonTerm), get\_dict(map, JsonTerm, Map)
->  maplist(format('~~s~~n'), Map)
;   format('Invalid data format: ~~w~~n', \[JsonString])
).

client\_loop(Stream) :-
get\_single\_char(Char),
(   char\_code('q', Char)
->  format('Quitting...~~n', \[]),
close(Stream)
;   (   memberchk(Char, \[0'w, 0's, 0'a, 0'd])
->  format(Stream, '~~c~~n', \[Char]),
flush\_output(Stream),
(   read\_line\_to\_string(Stream, Response)
->  format('~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n', \[]),
display\_map(Response)
;   format('Server disconnected\~n', \[]),
close(Stream)
)
;   true
),
client\_loop(Stream)
).

\:- connect\_to\_server.
