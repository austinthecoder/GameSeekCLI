# GameSeekCLI

## Usage

The GameSeekCLI requires a GameSeek endpoint application. By default, it expects this endpoint to be at `localhost:3000`. Otherwise it uses the value in the environment variable `GAME_SEEK_HOST`.

### Examples

#### Print a list of the survey responses

```
$ ./bin/gs list
+--------+---------------+--------+-------------+---------------------------------+
| Person | Platform      | Genre  | Price Range | Games                           |
+--------+---------------+--------+-------------+---------------------------------+
| Austin | Xbox 360      | Sports | $30 to $70  | NHL 13                          |
|        |               |        |             | NCAA Football 13                |
|        |               |        |             | Tiger Woods PGA TOUR 13         |
+--------+---------------+--------+-------------+---------------------------------+
| Jack   | PlayStation 3 | Action | any to $70  | Army of Two: The Devil's Cartel |
|        |               |        |             | Dead Space 3                    |
|        |               |        |             | Mass Effect 3                   |
|        |               |        |             | Shadows of the Damned           |
|        |               |        |             | Alice: Madness Returns          |
+--------+---------------+--------+-------------+---------------------------------+
```

#### Remove a game from the system

```
$ ./bin/gs remove_game 347865
Game was removed.
```

## Testing

* Run `bundle exec rspec spec` to run the test suite