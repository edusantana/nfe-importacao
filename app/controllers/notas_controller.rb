class NotasController < ApplicationController
  before_action :set_nota, only: [:show, :edit, :update, :destroy, :download_txt]

  # GET /notas
  # GET /notas.json
  def index
    @notas = Nota.all
  end

  # GET /notas/1
  # GET /notas/1.json
  def show
  end

  # Retorna txt da nota
  # GET /notas/1/download_txt
  def download_txt
    @nota.calcula
    send_data @nota.to_txt, type: 'text/plain', filename: "nota-fiscal-#{@nota.id}.txt"
  end

  # GET /notas/new
  def new
    @nota = Nota.new()
    @nota.user = current_user
  end

  # GET /notas/1/edit
  def edit
  end

  # POST /notas
  # POST /notas.json
  def create
    @nota = Nota.new(nota_params)
    @nota.user = current_user

    respond_to do |format|
      if @nota.save
        format.html { redirect_to @nota, notice: 'Nota foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @nota }
      else
        format.html { render :new }
        format.json { render json: @nota.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notas/1
  # PATCH/PUT /notas/1.json
  def update
    respond_to do |format|
      if @nota.update(nota_params)
        format.html { redirect_to @nota, notice: 'Nota was successfully updated.' }
        format.json { render :show, status: :ok, location: @nota }
      else
        format.html { render :edit }
        format.json { render json: @nota.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notas/1
  # DELETE /notas/1.json
  def destroy
    @nota.destroy
    respond_to do |format|
      format.html { redirect_to notas_url, notice: 'Nota foi apagada com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nota
      @nota = Nota.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nota_params
      params.fetch(:nota, {}).permit(:titulo, :planilha_itens)
    end
end
