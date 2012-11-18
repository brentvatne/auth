module Api
  class SampleClient
    class << self
      def baseUrl
        @baseUrl ||=
          'http://nsscreencast-auth-server.herokuapp.com'
      end

      # Valid response:
      #
      # { "auth_token_expires_at" => "2012-11-18T02:26:38Z",
      #   "username"              => "admin4",
      #   "auth_token"            => "1b9fabe2b36e81a6c7a6991a0353fe5355ec13f7",
      #   "email"                 => "admin4@example.com" }
      #
      def authenticate(login, password, &block)
        SVProgressHUD.show

        payload = {payload: {username: login, password: password}}
        BW::HTTP.post(authenticationPath, payload) do |response|
          if response.ok?
            SVProgressHUD.showSuccessWithStatus('Logged in')
            parsedResponse = BW::JSON.parse(response.body.to_str)
            saveNewToken(parsedResponse[:auth_token])
            block.call(true, parsedResponse)
          else
            error = 'Invalid credentials'
            SVProgressHUD.showErrorWithStatus(error)
            block.call(false, error)
          end
        end
      end

      def fetchIndex(&block)
        SVProgressHUD.show

        getWithToken(indexPath) do |response|
          if response.respond_to?(:never_requested?) && response.never_requested?
            SVProgressHUD.dismiss
            block.call(false, 'Not authenticated')
          elsif response.ok?
            SVProgressHUD.dismiss
            block.call(true, response.body.to_str)
          elsif response.status_description == 'unauthorized'
            forceAuthentication
            SVProgressHUD.showErrorWithStatus('Your session has expired, please login again')
            block.call(false, 'Token expired')
          end
        end
      end

      def getWithToken(path, &block)
        if ! authenticated?
          block.call(NoRequestSent.new)
          return forceAuthentication
        end

        options = {headers: {'auth_token' => token}}
        BW::HTTP.get(path, options) do |response|
          block.call(response)
        end
      end

      class NoRequestSent
        def never_requested?
          true
        end
      end

      def authenticated?
        !!token
      end

      def authenticationPath
        "#{baseUrl}/auth/login.json"
      end

      def indexPath
        "#{baseUrl}/home/index.json"
      end

      def forceAuthentication
        App.notification_center.post 'UnauthorizedRequest'
      end

      def token
        App::Persistence['SampleToken']
      end

      def clearToken
        App::Persistence['SampleToken'] = nil
      end

      def saveNewToken(token)
        App::Persistence['SampleToken'] = token
      end
    end
  end
end
