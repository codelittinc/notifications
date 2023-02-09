# frozen_string_literal: true

module Admin
  module Actions
    class ReplayNotificationRequest < RailsAdmin::Config::Actions::Base
      RailsAdmin::Config::Actions.register(ReplayNotificationRequest)

      register_instance_option :member do
        true
      end

      register_instance_option :visible? do
        bindings[:object].is_a?(NotificationRequest)
      end

      register_instance_option :http_methods do
        %i[get]
      end

      register_instance_option :link_icon do
        # FontAwesome Icons
        'icon-repeat'
      end

      register_instance_option :controller do
        proc do
          flash[:success] = t('admin.actions.replay_notification_request.success')
          if Rails.env.production?
            HardWorker.perform_async(@object.id)
          else
            MessageSender.call(@object)
          end
          redirect_to back_or_index
        end
      end
    end
  end
end
