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
# saves the user on the db
# Try quering `user.password`, you'll probably get `nil`. This is because the password's are hashed before storing.
```

> Before storing the `email_address`, they are normalized and checked for a valid `email_address`.

Now, let's create a post. We will reference the above created `user` when creating a `post`.

```ruby
post = user.posts.build(title: 'My first blog post', content: 'Hello world, an awesome day indeed')
post.save
```

> This creates a `post` and the `user_id` column is populated with the `user`'s id.

Now, let's comment on the post that we created above. Because that's what reddit does right?

```ruby
comment = post.comments.build(content: 'Wow, an awesome post', user: user)
comment.save
```

> Comment is created and the `post_id` and the `user_id` is populated automatically.

You want to comment on a comment? No problem

```ruby
nested_comment = comment.comments.build(content: 'I am a nested comment', user: user)
nested_comment.save
```

Phew, we did a lot. But we still have more to go. Let's try the upvote and the downvote feature.

```ruby
post.upvote

# This creates a `vote` instance on the `post`.

post.votes_count

# 1

post.downvote(1) # Here 1 is the `id` of the vote that we created earlier. Normally, we could have used the controller to fetch the params and pass in the argument.
```

Similarly, lets vote on the comment

```ruby
comment.upvote

# and

comment.downvote(2) # The `id` may change here. Please be cautious.
```

Similarly, lets vote on a nested comment

```ruby
nested_comment.upvote

# and

nested_comment.downvote(3) # The `id` may change here. Please be cautious.
```

Last but not the least, the bookmark or the save feature as reddit likes to call it.

```ruby
post.bookmarks.create! user: user
comment.bookmarks.create! user: user
nested_comment.bookmarks.create! user: user
```

And similarly you can `update` and `destroy` the records accordingly.
