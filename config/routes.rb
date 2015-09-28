Rails.application.routes.draw do


  get 'sponsored_posts/index'

  get 'sponsored_posts/show'

  get 'sponsored_posts/new'

  get 'sponsored_posts/edit'

=begin
  get 'posts/index'

  get 'posts/show'

  get 'posts/new'

  get 'posts/edit'

1 - WE call the resources method and pass it a symbol...instructs Rails to
create post routes for creating, updaing, viewing, and deleting instances of Post
=end
  resources :advertisements, :questions
  resources :topics do
     resources :posts, except: [:index]
     resources :sponsored_posts, except: [:index]
   end
=begin

  get 'welcome/index'

  get 'welcome/about'

2 - we remove get "welcome/index" because we've declared the index view as the
root view.  We also modify the about route to allow users to type /about, rather
than /welcome/about.
=end

  get 'about' => 'welcome#about'

  get 'welcome/contact'

  get 'welcome/faq'

  root({to: 'welcome#index'})
end
