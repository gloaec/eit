class ProgramsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_authorize_resource :only => :events
  before_action :set_program, only: [:show, :edit, :update, :destroy]
  before_action :set_programs, only: [:index]

  # GET /events.json
  def events
    from = Time.at(params[:from].to_i/1000)
    to = Time.at(params[:to].to_i/1000)
    @programs = Program
    .where(start_at: from.beginning_of_day..to.end_of_day)
    .select {|_| can?(:read, _)}
  end

  # GET /programs
  # GET /programs.json
  def index
  end

  # GET /programs/1
  # GET /programs/1.json
  def show
  end

  # GET /programs/new
  def new
    @program = Program.new
  end

  # GET /programs/1/edit
  def edit
  end

  # POST /programs
  # POST /programs.json
  def create
    @program = Program.new(program_params)

    respond_to do |format|
      if @program.save
        format.html { redirect_to @program, notice: 'Program was successfully created.' }
        format.json { render action: 'show', status: :created, location: @program }
      else
        format.html { render action: 'new' }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /programs/1
  # PATCH/PUT /programs/1.json
  def update
    respond_to do |format|
      if @program.update(program_params)
        format.html { redirect_to @program, notice: 'Program was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /programs/1
  # DELETE /programs/1.json
  def destroy
    @program.destroy
    respond_to do |format|
      format.html { redirect_to programs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program
      @program = Program.find(params[:id])
    end

    def set_programs
      @programs = Program
      .order(created_at: :desc)
      .select {|_| can?(:read, _)}
      .group_by{ |u| u.created_at.beginning_of_day }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def program_params
      params.require(:program).permit(:name, :queue_path, :success_path, :error_path)
    end
end
