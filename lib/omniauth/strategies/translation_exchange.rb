#--
# Copyright (c) 2015 Translation Exchange, Inc
#
#  _______                  _       _   _             ______          _
# |__   __|                | |     | | (_)           |  ____|        | |
#    | |_ __ __ _ _ __  ___| | __ _| |_ _  ___  _ __ | |__  __  _____| |__   __ _ _ __   __ _  ___
#    | | '__/ _` | '_ \/ __| |/ _` | __| |/ _ \| '_ \|  __| \ \/ / __| '_ \ / _` | '_ \ / _` |/ _ \
#    | | | | (_| | | | \__ \ | (_| | |_| | (_) | | | | |____ >  < (__| | | | (_| | | | | (_| |  __/
#    |_|_|  \__,_|_| |_|___/_|\__,_|\__|_|\___/|_| |_|______/_/\_\___|_| |_|\__,_|_| |_|\__, |\___|
#                                                                                        __/ |
#                                                                                       |___/
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class TranslationExchange < OmniAuth::Strategies::OAuth2

      option :client_options, {
        :site           => 'http://localhost:3000',
        :authorize_url  => 'http://localhost:3008/oauth/authorize',
        :token_url      => 'http://localhost:3008/oauth/token'
      }

      # option :client_options, {
      #   :site           => 'https://api.translationexchange.com',
      #   :authorize_url  => 'https://gateway.translationexchange.com/oauth/authorize',
      #   :token_url      => 'https://gateway.translationexchange.com/oauth/token'
      # }

      option :name, 'translationexchange'

      option :access_token_options, {
        :header_format => 'OAuth %s',
        :param_name => 'access_token'
      }
      
      option :authorize_options, [:scope, :display]

      def request_phase
        super
      end

      uid { raw_info['id'] }
      
      info do
        prune!({
          'id'             => raw_info['id'],
          'display_name'   => raw_info['display_name'],
          'first_name'     => raw_info['first_name'],
          'last_name'      => raw_info['last_name'],
          'email'          => raw_info['email'],
          'gender'         => raw_info['gender'],
          'mugshot'        => raw_info['mugshot']
        })
      end
      
      extra do 
        { 'user' =>  prune!(raw_info) }
      end
      
      def raw_info
        @raw_info ||= access_token.get('/v1/users/me').parsed
      end

      def authorize_params
        super.tap do |params|
          params.merge!(:display => request.params['display']) if request.params['display']
          params.merge!(:state => request.params['state']) if request.params['state']
        end
      end

      private

      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

    end
  end
end

OmniAuth.config.add_camelization 'translationexchange', 'TranslationExchange'
