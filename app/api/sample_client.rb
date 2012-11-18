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
        payload = {payload: {username: login, password: password}}

        BW::HTTP.post(authenticationPath, payload) do |response|
          if response.ok?
            parsedResponse = BW::JSON.parse(response.body.to_str)
            saveNewToken(parsedResponse[:auth_token])
            $stdout.puts parsedResponse
            block.call(true, parsedResponse)
          elsif response.status_code.to_s =~ /40\d/
            App.alert("Invalid credentials")
            block.call(false, nil)
          else
            App.alert("Server error")
            block.call(false, nil)
          end
        end
      end

      def fetchIndex(&block)
        getWithToken(indexPath) do |response|
          if response.ok?
            parsedResponse = BW::JSON.parse(response.body.to_str)
            block.call(true, response.body.to_str)
          elsif response.status_description == 'unauthorized'
            forceAuthentication
            block.call(false, 'Something went wrong')
          end
        end
      end

      def authenticated?
        !!token
      end

      def authenticationPath
        "#{baseUrl}/auth/login.json"
      end

      def getWithToken(path, &block)
        return forceAuthentication unless authenticated?

        options = {headers: {'auth_token' => token}}
        BW::HTTP.get(path, options) do |response|
          block.call(response)
        end
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
