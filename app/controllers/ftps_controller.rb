class FtpsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_ftp, only: [:show, :edit, :update, :destroy]

  # GET /ftps
  # GET /ftps.json
  def index
    @ftps = Ftp.all
  end

  # GET /ftps/1
  # GET /ftps/1.json
  def show
  end

  # GET /ftps/new
  def new
    @ftp = Ftp.new
  end

  # GET /ftps/1/edit
  def edit
  end

  # POST /ftps
  # POST /ftps.json
  def create
    @ftp = Ftp.new(ftp_params)

    respond_to do |format|
      if @ftp.save
        format.html { redirect_to @ftp, notice: 'Ftp was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ftp }
      else
        format.html { render action: 'new' }
        format.json { render json: @ftp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ftps/1
  # PATCH/PUT /ftps/1.json
  def update
    respond_to do |format|
      if @ftp.update(ftp_params)
        format.html { redirect_to @ftp, notice: 'Ftp was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ftp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ftps/1
  # DELETE /ftps/1.json
  def destroy
    @ftp.destroy
    respond_to do |format|
      format.html { redirect_to ftps_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ftp
      @ftp = Ftp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ftp_params
      params.require(:ftp).permit(:host, :post, :user, :password_digest, :root_path, :channel)
    end
end
