# frozen_string_literal: true

class ImagesController < ApplicationController
  skip_forgery_protection

  def show
    send_data image.data, disposition: 'inline', type: image.mime
  end

  MAX_IMAGE_SIZE = 2 * 1024 * 1024

  def create
    return head 413 if request.headers['Content-Length'].to_i > MAX_IMAGE_SIZE

    data = request.body.read
    return head 422 if data.length > MAX_IMAGE_SIZE

    mime = Marcel::MimeType.for data
    image = Image.create(data:, size: data.length, mime:)
    object.images << image

    redirect_to image_path(image)
  end

  private

  def object
    @object ||= if params[:item_id]
                  Item.find(params[:item_id])
                elsif params[:npc_id]
                  Npc.find(params[:npc_id])
                elsif params[:monster_id]
                  Monster.find(params[:monster_id])
                end
  end

  def image
    @image ||= Image.find(params[:id])
  end
end
