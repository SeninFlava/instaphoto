class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :is_user_owner, only: [:edit, :update, :destroy]

  # GET /photos
  # GET /photos.json
  def index
    @photos =  Photo.all
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = current_user.photos.build #Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = current_user.photos.build(photo_params) #Photo.new(photo_params)


      if @photo.save
        redirect_to '/photos', notice: 'Photo was successfully created.'
        #render 'index'
        #redirect_to @photo, notice: 'Photo was successfully created.'
      else
        render action: 'new'
      end
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
      if @photo.update(photo_params)
        redirect_to @photo, notice: 'Photo was successfully updated.'
      else
        render action: 'edit'
      end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo.destroy
    redirect_to photos_url
  end

  private

    def is_user_owner
      @photo = Photo.find_by(id: params[:id])
      redirect_to "/photos" if @photo.nil? 
      redirect_to "/photos" if @photo.user != current_user
    end


    def set_photo
      @photo = Photo.find_by(id: params[:id])
      redirect_to "/photos" if @photo.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:description)
    end
end
