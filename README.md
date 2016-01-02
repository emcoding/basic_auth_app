This is a basic app based upon Railscast #250: authentication from scratch, adjusted for:

- Ruby 2.2.2
- Rails 4.2.3

>`has_secure_password` is an instance method of the ActiveModel::SecurePassword module, that is included in
> Active Record. THe corresponding model needs to have the password_digest attribute. 
> It also adds some validations and an important :authenticate method. This method compares a password input with the password_digest in the database.
> bcrypt gem takes care of the encryption of the saved password(digest).

Steps to get there:
(See commits for code details)

##Part 1: Basic setup

With a (new) app in place:
####1) add user model and controller with 

```ruby 
rails g resource user email password_digest
rake db: migrate
```

:bulb:

- resource generator generates model, controller and routes  
- with string-type attributes, you don't need to specify the type of the key.  
- password_digest : don't change this key, it is required for the `has_secure_password`

####2) Add has_secure_password method
In model user.rb, add has_secure_password method.
Also, add validation of uniqueness for email.
In gemfile: uncomment `bcrypt`, make it '-> 3.1.7'
(Older Rails versions required bcrypt-ruby.)

:bulb:

* has_secure_password comes with built in methods, like :authenticate,  
and all kind of validations, including password_confirmation,
 in order to set and authenticate against bcrypt.  
 It uses a password_digest attribute.
   * You can skip password_confirmation by leaving it out of the form/attributes.
* Change in Bates' setup:
 I didn't add the attr_accessible parameters.
 From Rails4 on, it is no longer needed in the model, we'll add it in the Controller 
 as strong parameters.
 
 * I didn't add a validation for email against VALID_REGEX, because rumour has it, that it is 
 hard to find all existing email formats in a REGEX. Alternative solution is to add a 
 mailer for email confirmation #TODO
 
####3) Add sign up functionality so that user can sign up
Signing up is done in the users_controller. Add new method, and add form in view.

* Changed in Bates' setup 
In a later commit (SHA: e6bcab90475ca0518eac01dd87039c67a658e6c9) I changed email text_field into :email email_field. Now, some mobile browsers will bring up the email 
keyboard.

####4) Now for the actual authentication: add log in
This is done by creating a Session instance. 
Add sessions_controller, with :authenticate method in :create action.
With appropriate routing and view w form.

:bulb:  

`session[:user_id] = user.id ` places a temporary cookie on the user’s browser 
containing an encrypted ( or: hashed?) version of the user’s id. Now we can retrieve the id on subsequent pages using 
`session[:user_id]`.
 

####5) Make current_user method, to make logged in status visible 
Use User.find(session[:user_id] (see sessions_controller) to def a current_user helper method
 Now you can add conditional to view to check for logged in status
 
####6) Add log out functionality
 Log out == delete session. Add :destroy method
 
:bulb:
- in view: link_to session_path(xxx): session_path expects a parameter, but our destroy method doesn't use this 
parameter, so you can call it whatever you like.

####7) Make prettier route names
Change routes to named routes. Adjust link_to path names accordingly

:bulb:
- change in Bates' set up:
name the destroy route the restful way: with `delete` verb. 
In that case, the link_to logout_path in view *does* need the `, method: :delete` (which Bates deletes).

* Why do we need this `method:`-thingy with a delete route??? That is because browsers don't do destroy.
Rails solves this with a JavaScript workaround 
(JavaScript is the programming language for (most) browsers.) 

####8) Let signed up user be logged in automatically
Add log in from sessions_controller to sign up in users_controller. 
[x] TODO : move (doubled) code to a helper, in order to solve duplication. (Put in applications_helper, until that file
becomes overloaded, then move it to sessions_helper)

####9) Instead of Bates Log in and authorize, we will add gem CanCanCan for managing authorizations

####10) Bates sequence: Store cookie and Reset password in RailsCast #274
 
##To DO
 
- [x] Check Hartl
  - [x] In users/new.html.erb Change email: f.textfield to f.email_field (since R3)
- [ ] Add tests    
- [x] Restrict routes to :only routes in use. (Because complex routing consumes a lot of memory;
=> Discard unnecessary and unused routes.)
- [ ] Optimize UI for logging in and signing up
- [ ] Add CanCanCan authorization
- [ ] Add css
- [ ] http://zurb.com/university/lessons/prevent-trouble-with-social-logins


is this correct?
By making sessions a RESTful resource with just the following rules:

A session maps a key to a user id (and possibly a last-action-timestamp for timeouts)
If a session exists, then that means that the key is valid.
Login means POSTing to /sessions, a new key is set as a cookie
Logout means DELETEing /sessions/{key} (with overloaded POST, remember, we're a browser and HTML 5 is a long way to go yet)
Authentication is done by sending the key as a cookie at every request and checking whether the session exists and is valid