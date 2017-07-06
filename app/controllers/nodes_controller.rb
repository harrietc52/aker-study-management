class NodesController < ApplicationController

  include AkerAuthenticationGem::AuthController
  include AkerPermissionControllerConfig

  skip_authorization_check

  before_action :current_node, except: :create
  before_action :set_child, only: [:show, :list, :tree]

  def show
    render "list"
  end

  def index
    render "list"
  end

  def list
  end

  def tree
  end

  def create
    @node = Node.new(node_params)

    @node.owner = current_user

    if @node.save
      flash[:success] = "Node created"
      @node.set_collection if @node.level==2
    else
      flash[:danger] = "Failed to create node"
    end
    redirect_to node_path(@node.parent_id)
  end

  def edit
    respond_to do |format|
      format.html
      format.js { render template: 'nodes/modal' }
    end
  end

  def update
    unless @node.check_privilege(current_user, :editor)
      raise "#{current_user.email} does not have the correct privileges to update node #{@node.id}."
      return
    end
    respond_to do |format|
      if @node.update_attributes(node_params)
        format.html { redirect_to node_path(@node.parent_id), flash: { success: "Node updated" }}
        format.json { render json: @node, status: :ok }
      else
        format.html { redirect_to edit_node_path(@node.id), flash: { danger: "Failed to update node" }}
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @parent_id = @node.parent_id

    if @node.deactivate(current_user)
      flash[:success] = "Node deleted"
      redirect_to node_path(@parent_id)
    else
      flash[:danger] = @node.errors.empty? ? "This node cannot be deleted." : @node.errors.full_messages.join(" ")
      redirect_to node_path(@parent_id)
    end
  end

  helper_method :check_editor_privilege, :check_editor_privilege_for_node

  private

  def set_child
    @child = Node.new(parent: @node)
  end

  def current_node
    @node = (params[:id] && Node.find_by_id(params[:id])) || Node.root
  end

  def node_params
    params.require(:node).permit(:name, :parent_id, :description, :cost_code)
  end

  def check_editor_privilege
    @node.check_privilege(current_user, :editor)
  end

  def check_editor_privilege_for_node(n)
    n.check_privilege(current_user, :editor)
  end

end
