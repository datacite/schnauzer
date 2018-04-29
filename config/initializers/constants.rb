RESCUABLE_EXCEPTIONS = [JSON::ParserError,
                        ActionController::RoutingError,
                        ActionController::ParameterMissing,
                        ActionController::UnpermittedParameters,
                        Elasticsearch::Transport::Transport::Errors::NotFound,
                        NoMethodError]