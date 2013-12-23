class Auth::RegistrationsController < Devise::RegistrationsController
  layout 'no_navbar', :except => :edit

  def sign_up_params
    super.merge :locked => true
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    if resource.save
      yield resource if block_given?
      set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
      expire_data_after_sign_in!
      respond_with resource, :location => new_user_session_path
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if update_resource(resource, account_update_params.merge({:name => params[:user][:name]}))
      avatar_io = params[:user][:avatar]
      if avatar_io.present?
        resource.avatar = resource.id
        File.open Rails.root.join('public', 'images', 'avatar', "#{resource.avatar}.png"), 'wb' do |file|
          file.write(avatar_io.read)
        end
        resource.save
      end
      yield resource if block_given?
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      redirect_to edit_user_registration_path
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

end