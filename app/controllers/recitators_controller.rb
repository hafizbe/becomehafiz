class RecitatorsController < ApplicationController
  # GET /recitators
  # GET /recitators.json
  def index
    @recitators = Recitator.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @recitators }
    end
  end

  # GET /recitators/1
  # GET /recitators/1.json
  def show
    @recitator = Recitator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @recitator }
    end
  end

  # GET /recitators/new
  # GET /recitators/new.json
  def new
    @recitator = Recitator.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @recitator }
    end
  end

  # GET /recitators/1/edit
  def edit
    @recitator = Recitator.find(params[:id])
  end

  # POST /recitators
  # POST /recitators.json
  def create
    @recitator = Recitator.new(params[:recitator])

    respond_to do |format|
      if @recitator.save
        format.html { redirect_to @recitator, notice: 'Recitator was successfully created.' }
        format.json { render json: @recitator, status: :created, location: @recitator }
      else
        format.html { render action: "new" }
        format.json { render json: @recitator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /recitators/1
  # PUT /recitators/1.json
  def update
    @recitator = Recitator.find(params[:id])

    respond_to do |format|
      if @recitator.update_attributes (params[:recitator])
        format.html { redirect_to @recitator, notice: 'Recitator was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @recitator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recitators/1
  # DELETE /recitators/1.json
  def destroy
    @recitator = Recitator.find(params[:id])
    @recitator.destroy

    respond_to do |format|
      format.html { redirect_to recitators_url }
      format.json { head :no_content }
    end
  end
end
