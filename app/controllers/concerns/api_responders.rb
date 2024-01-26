module ApiResponders
  extend ActiveSupport::Concern
  
  # Use to render success response.
  def render_success(data, status = :ok)
    render json: { status: 'SUCCESS', data: data }, status: status
  end
  
  # Use to render error response.
  def render_error(message, status = :unprocessable_entity)
    render json: { status: 'ERROR', error: message }, status: status
  end
end
