class PostsController < ApplicationController

# we use a before_action filter to call the require_sign_in method before each of our
# controller actions, except for the show action.
  before_action :require_sign_in, except: :show

  before_action :authorize_user_for_update, except: [:show, :new, :create,  :destroy]
  before_action :authorize_user_for_destroy, only: [:destroy]




  def show
# we find the post that corresponds to the id in the params that was passed to show
# and assign it to @post. Unlike in the index method, in the show method, we populate
# an instance variable with a single post, rather than a collection of posts.
    @post = Post.find(params[:id])
  end

  def new
    @topic = Topic.find(params[:topic_id])
# we create an instance variable, @post, then assign it an empty post returned by Post.new
    @post = Post.new
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(post_params)

# we assign @post.user in the same way we assigned @post.topic, to properly scope the new post
    @post.user = current_user
# if saving the post was successufl, we display success message using flash[:notice]
# and redirect the user tot he route generated by @post. Redirecting to @post will
# direct the user to the posts show view.
    if @post.save
      @post.labels = Label.update_labels(params[:post][:labels])
      #@post.ratings = Rating.update_rating(params[:post][:ratings])

# we assign a value to flash[:notice]. the flash hash provides a way to pass temporary
# values between actions. Any value placed in flash will be available in next action
# and then deleted.
      flash[:notice] = "Post was saved."
      redirect_to [@topic, @post]
    else
# if saving the instance of post was not successful, we display an eror message
# and render the new view again.
      flash[:error] = "There was an error saving the post. Please try again."
      render :new
    end
  end
# Unlike new, create does not have a corresponding view as it works behind the scenes
# to collect the data submitted by the user and update the database. create is a POST action.

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.assign_attributes(post_params)


    if @post.save
      @post.labels = Label.update_labels(params[:post][:labels])
      #@post.ratings = Rating.update_rating(params[:post][:ratings])
      flash[:notice] = "Post was updated."
      redirect_to [@post.topic, @post]
    else
      flash[:error] = "There was an error saving the post. Please try again."
      render :edit
    end
  end

  def destroy

    @post = Post.find(params[:id])


# we call destroy on @post, we call was successful we set a flash message and
# redirect the user tot he posts index view... if it fails we redirect the user
# to show view using render :show.
    if @post.destroy
      flash[:notice] = "\"#{@post.title}\" was deleted successfullly."
      redirect_to @post.topic
    else
      flash[:error] = "There was an error deleting the post."
      render :show
    end
  end


  private

  def post_params
    params.require(:post).permit(:title, :body)
  end


  def authorize_user
    post = Post.find(params[:id])
#
    unless current_user == post.user || current_user.admin? || current_user.moderator?
      flash[:error] = "You must be authorized to do that."
      redirect_to [post.topic, post]
    end
  end

  def authorize_user_for_update
    post = Post.find(params[:id])
#
    unless current_user == post.user || current_user.admin? || current_user.moderator?
      flash[:error] = "You must be authorized to do that."
      redirect_to [post.topic, post]
    end
  end

  def authorize_user_for_destroy
    post = Post.find(params[:id])
#
    unless current_user == post.user || current_user.admin?
      flash[:error] = "You must be authorized to do that."
      redirect_to [post.topic, post]
    end
  end


end
