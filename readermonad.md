# Reader Monad
## Reader Monad
Alexandre Bergeron
Backend Developer @Wajam
@AlexBergeron2

Scala Montreal
March 26th, 2014

## An introduction
    def getUsers(): List[User] = {
      val c = Database.getConnection()
      try {
        val rs = c.executeQuery("SELECT * FROM Users")
        User.fromResultSet(rs)
      } catch {
        case t => Nil
      } finally {
        c.close()
      }
    }

## Extracting connection handling logic
    def getUsers(c: Connection): List[User] = {
      try {
        val rs = c.executeQuery("SELECT * FROM Users")
        User.fromResultSet(rs)
      } catch {
        case t => Nil
      }
    }

## Using it
    // Giving a user admin rights
    val c = Database.getConnection()
    try {
      val u = getUserById(id, c)
      updateUser(id, u.copy(rights = u.rights + Rights.Admin), c)
    } finally {
      c.close()
    }

## Dependency injection using implicits
    implicit val c = Database.getConnection()
    try {
      val u = getUserById(id)
      updateUser(id, u.copy(rights = u.rights + Rights.Admin))
    } finally {
      c.close()
    }

## Ideal solution
- Easy to compose
- Could delay handling of connection as late as possible
- Avoids polluting the code with implicits
- Avoids complex dependency injection frameworks

## Contents
- What is a Monad
- What is a reader monad
- Use cases

# What is a Monad
## Tutorials about monads
![](Monad-tutorials-chart.png)
(Monads Tutorial timeline - http://www.haskell.org/haskellwiki/Monad_tutorials_timeline)

## What a Monad is not
- A burrito (http://blog.plover.com/prog/burritos.html)
- The most primal aspect of God in Gnosticism (http://en.wikipedia.org/wiki/Monad_(Gnosticism))
- Overly complex mathematical concept only Haskellers find usefull

## You're (probably) already using Monads
- (most)  Collections, Option, Future
- Iteratees, Reactive Observables
- ScalaCheck Generator
- Anytime you're using for comprehensions, you're doing Monad composition

## Monads in Scala
(Simplified for the sake of this talk)

- A type M with a type parameter A
- Exposes
  - `map[B](f: A => B): M[B]`
  - `flatMap[B](f: A => M[B]): M[B]`

# Reader Monad
## Basic Idea
- Allows for composition of functions taking a parameter of the same type
- 

## Implementation
    case class Reader[C, A](private run: C => A) {
      def apply(c: C): A = run(c)
      def map[B](f: A => B): Reader[C, B] =
        Reader(c => f(run(c)))
      def flatMap[B](f: A => Reader[C, B]): Reader[C, B] = 
        Reader(c => f(run(c))(c))
    }

## Monadified example
    def grantAdmin(id: Int): Reader[Connection, Unit] = for {
      u <- getUserById(id)
      r <- updateUser(id, u.copy(rights = u.rights + Rights.Admin))
    } yield r

    grantAdmin(id)(Database.getConnection())

- Composable
- Explicit dependency
- Avoids polluting the implicit namespace
- Framework-less
- Data-flow driven

## Possible problems
- Composing with other Monads is difficult
  - See Monad Transformers
- Composition requires for comprehensions or flatMapping - Losing simple functions
- 

# Other use cases
- ???

# More about Reader Monads
(Link to Runar's talk)

# Questions?
Thanks for listening
Made with Pandoc, Markdown and reveal.js
