# Micro Reddit

A simple rails console app based on the [reddit](https://reddit.com) platform.

## Getting started

- Clone the repo `https://github.com/abeidahmed/micro-reddit.git`
- `cd` into the directory
- Run `git checkout -b reddit-model-feature`
- Run `git pull origin reddit-model-feature`
- Run `bundle install`
- Setup your db, and run `rails db:create db:migrate`

## Features

- Users can register themselves.
- Create a post.
- Comment on a post.
- Comment on a comment.
- Reddit style upvotes and downvotes on both posts and comments.
- Bookmark posts and comments.

## Usage

The first thing that you need to do is to fire up a `rails console`.

Let's get started by creating a `user`.

```ruby
user = User.create! full_name: 'John Doe', email_address: 'johnny@ex.com', password: 'secretpassword'

=> #<User id: 1, full_name: "John Doe", email_address: "johnny@ex.com", password_digest: [FILTERED], ...etc>
# Try quering `user.password`, you'll probably get `nil`. This is because the password's are hashed before storing.
```

> Before storing the `email_address`, they are normalized and checked for a valid `email_address`.

Now, let's create a post. We will reference the above created `user` when creating a `post`.

```ruby
post = user.posts.build(title: 'My first blog post', content: 'Hello world, an awesome day indeed')
post.save

=> #<Post id: 1, title: "My first blog post", content: "Hello world, an awesome day indeed", votes_count: 0, user_id: 1, .... etc>
```

> This creates a `post` and the `user_id` column is populated with the `user`'s id.

Now, let's comment on the post that we created above. Because that's what reddit does right?

```ruby
comment = post.comments.build(content: 'Wow, an awesome post', user: user)
comment.save

#<Comment id: 1, content: "Wow, an awesome post", votes_count: 0, commentable_type: "Post", commentable_id: 1, user_id: 1, ... etc>
```

> Comment is created and the `post_id` and the `user_id` is populated automatically.

You want to comment on a comment? No problem

```ruby
nested_comment = comment.comments.build(content: 'I am a nested comment', user: user)
nested_comment.save

#<Comment id: 2, content: "I am a nested comment", votes_count: 0, commentable_type: "Comment", commentable_id: 1, user_id: 1, ...etc>
```

Phew, we did a lot. But we still have more to go. Let's try the upvote and the downvote feature.

```ruby
post.upvote
#<Vote id: 1, votable_type: "Post", votable_id: 1, ...etc>

# This creates a `vote` instance on the `post`.

post.votes_count
# 1

post.downvote(1) # Here 1 is the `id` of the vote that we created earlier. Normally, we could have used the controller to fetch the params and pass in the argument.
# DELETE FROM "votes" WHERE "votes"."id" = $1  [["id", 1]]

post.votes_count
# 0
```

Similarly, lets vote on the comment

```ruby
comment.upvote
#<Vote id: 2, votable_type: "Comment", votable_id: 1, ...etc>

comment.votes_count
# 1

# and

comment.downvote(2) # The `id` may change here. Please be cautious.
#<Vote id: 2, votable_type: "Comment", votable_id: 1, ...etc>

comment.votes_count
# 0
```

> The count feature is handled by the [`counter_cache`](https://api.rubyonrails.org/classes/ActiveRecord/CounterCache/ClassMethods.html) column.

Similarly, lets vote on a nested comment

```ruby
nested_comment.upvote
#<Vote id: 3, votable_type: "Comment", votable_id: 2, ...etc>

# and

nested_comment.downvote(3) # The `id` may change here. Please be cautious.
# DELETE FROM "votes" WHERE "votes"."id" = $1  [["id", 3]]
```

Last but not the least, the bookmark or the save feature as reddit likes to call it.

```ruby
post.bookmarks.create! user: user
=> #<Bookmark id: 1, bookmarkable_type: "Post", bookmarkable_id: 1, user_id: 1, ..etc>

comment.bookmarks.create! user: user
=> #<Bookmark id: 2, bookmarkable_type: "Comment", bookmarkable_id: 1, user_id: 1, ...etc>

nested_comment.bookmarks.create! user: user
=> #<Bookmark id: 3, bookmarkable_type: "Comment", bookmarkable_id: 2, user_id: 1, ...etc>
```

And similarly you can `update` and `destroy` the records accordingly.
