# frozen_string_literal: true

module AliexpressAPI
  class DsLogistic < Base
    class << self
      def freights(params = {})
        params = {
          method: 'aliexpress.logistics.buyer.freight.calculate',
          param_aeop_freight_calculate_for_buyer_d_t_o: params.dup
        }

        response = post(service_endpoint, params)
        result = response['aliexpress_logistics_buyer_freight_calculate_response']['result']

        unless result['success']
          raise ResultError.new(result, message: result['error_desc'])
        end

        list = result['aeop_freight_calculate_result_for_buyer_d_t_o_list']['aeop_freight_calculate_result_for_buyer_dto']
        list.map(&:with_indifferent_access)
      end

      def tracking_info(params)
        params = params.merge(
          method: 'aliexpress.logistics.ds.trackinginfo.query',
          origin: 'ESCROW'
        )
        response = post(service_endpoint, params)
        result = response['aliexpress_logistics_ds_trackinginfo_query_response']

        unless result['result_success']
          raise ResultError.new(result, message: result['error_desc'])
        end

        {
          official_website: result['official_website'],
          details: result['details']['details']
        }.with_indifferent_access
      end
    end
  end
end
