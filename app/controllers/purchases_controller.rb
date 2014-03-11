class PurchasesController < ApplicationController
  #layout false
  respond_to :js, :only => [:new, :create]
  def new
     @plan = params[:plan]
     @signature = Recurly.js.sign :subscription => { :plan_code => @plan }
     @purchase = Purchase.new
     @purchase.customer_id ||= SecureRandom.urlsafe_base64(16)
     respond_to do |format|
       format.js   # new.js.erb
       format.html # new.html.erb
     end
  end

  def create
    purchase = Purchase.new(params[:purchase])
    shot = params[:shot_id]
    stage = params[:stage_id]
    if purchase.save
      Delayed::Job.enqueue ProcessPurchaseJob.new(shot, stage, purchase.email)
      respond_to do |format|
        format.js   # new.js.erb
        format.html # new.html.erb
      end
    else
      status = :unprocessable_entity
      message = ""
    end
  end

  def update
    authorize! :update, @purchse, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    role = Role.find(params[:user][:role_ids]) unless params[:user][:role_ids].nil?
    params[:user] = params[:user].except(:role_ids)
    if @user.update_attributes(params[:user])
      @user.update_plan(role) unless role.nil?
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def SecureRandom.urlsafe_base64(n=nil, padding=false)
    s = [random_bytes(n)].pack("m*")
    s.delete!("\n")
    s.tr!("+/", "-_")
    s.delete!("=") if !padding
    s
  end
end
