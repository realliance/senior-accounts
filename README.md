# Game Accounts Service
### Senior Design CEN4914 Spring 2021

# Dependencies

- Git
- Ruby 3.0.0 with RubyGems

## Ruby with Arch Linux

It is recommended to use a version manager to handle your ruby versions, [rbenv](https://wiki.archlinux.org/index.php/Rbenv) with the [ruby-build](https://aur.archlinux.org/packages/ruby-build/) extension is recommended for this.

As of 1/17/2021, the `ruby-build` is flagged out of date due to not including the `ruby-3.0.0` version as an installable option. The `ruby-build` project itself has released a version for this, and can be installed with [these modifications to the PKGBUILD](https://aur.archlinux.org/packages/ruby-build/#comment-782770).

## A Note about Gems

It is best practice to install gems on a per-user basis. The use of `rbenv` should help facilitate this.

# Getting Started

```
# Install gems
bundle install

# Start Rails Server
rails s

# Run Linting and Style Checking
rubocop

# Run Unit Tests
rails spec
```
