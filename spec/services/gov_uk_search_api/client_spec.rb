require File.dirname(__FILE__) + '/../../rails_helper'

module GovUkSearchApi

  RSpec.describe Client, type: :model do

    let(:query) { 'Ministry of Justice' }
    let(:filtered_query) { 'Ministry Justice' }

    describe '#search' do

      let(:url_query) { "https://www.gov.uk/api/search.json?count=3&q=#{URI.encode(filtered_query)}" }

      context 'successful call to API' do
        it 'calls Curl with the URI encoded query and the curl response and returns a Response object' do
          curl_easy = double Curl::Easy
          response = double Response
          expect(Curl).to receive(:get).with(url_query).and_return(curl_easy)
          expect(Response).to receive(:new).with(query, curl_easy).and_return(response)

          actual_response = Client.new(query).search
          expect(actual_response).to eq response
        end
      end

      context 'Unsuccessful_call to API' do
        it 'instantiates an empty result with error details' do
          expect(Curl).to receive(:get).with(url_query).and_raise(Curl::Err::GotNothingError, 'No data')
          response = Client.new(query).search
          expect(response).to be_instance_of(Response)
          expect(response.num_items).to eq 0
          expect(response.error).to eq({
                                         'error' => {
                                           'event' => 'query_search',
                                           'search_term' => 'Ministry of Justice',
                                           'error_class' => 'Curl::Err::GotNothingError',
                                           'message' => 'No data'
                                         }
                                       })
        end
      end
    end

    describe '#more_results_url' do
      it 'returns the html gov uk query url with encoded query' do
        client = Client.new(query)
        expect(client.more_results_url).to eq 'https://www.gov.uk/search?q=Ministry%20Justice'
      end
    end
  end
end
