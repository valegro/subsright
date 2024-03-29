ActiveAdmin.register Publication do
  before_create { |publication| publication.api_key = Devise.friendly_token }
  permit_params :name, :image, :website, :description

  filter :name
  filter :image_updated_at
  filter :website
  filter :offers
  filter :subscriptions_count, label: 'Subscriptions'
  filter :description
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :name
    column :image do |publication|
      if publication.image?
        image_tag(publication.image.url(:thumb), size: '100')
      else
        content_tag(:span, 'None')
      end
    end
    column :website do |publication|
      link_to publication.website, publication.website
    end
    column :offers do |publication|
      ( publication.offers.order(:name).map { |offer| link_to offer.name, admin_offer_path(offer) }
      ).join(', ').html_safe
    end
    column :subscriptions, sortable: :subscriptions_count do |publication|
      if publication.subscriptions.size.zero?
        0
      else
        link_to publication.subscriptions.size, admin_subscriptions_path('q[publication_id_eq]' => publication.id)
      end
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :image do
        if publication.image?
          image_tag(publication.image.url :large)
        else
          content_tag(:span, 'None')
        end
      end
      row(:website) { link_to publication.website, publication.website }
      row(:api_key) { render 'api_key', locals: { publication: publication } }
      row :offers do
        ( publication.offers.order(:name).map { |offer| link_to offer.name, admin_offer_path(offer) }
        ).join(', ').html_safe
      end
      row :subscriptions do
        link_to pluralize(publication.subscriptions.size, 'subscription'),
          admin_subscriptions_path('q[publication_id_eq]' => publication.id) if publication.subscriptions.exists?
      end
      row(:description) { publication.description.html_safe unless publication.description.nil? }
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Publication Details' do
      f.input :name
      hint = f.publication.image? ? image_tag(f.publication.image.url) : content_tag(:span, 'Please upload an image')
      f.input :image, as: :file, hint: hint
      f.input :website, input_html: { rows: 1 }
      f.input :description, input_html: { class: 'tinymce' }
    end
    f.actions
  end

  member_action :new_key, method: :patch do
    Publication.find(params[:id]).update! api_key: Devise.friendly_token
    flash[:notice] = 'API key regenerated'
    redirect_to :admin_publication
  end
end
