import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/models/api_models.dart';
import '../../core/exceptions/api_exception.dart';

/// A reusable city search field with autocomplete dropdown
/// Automatically fetches state and country when a city is selected
class CitySearchField extends StatefulWidget {
  final TextEditingController cityController;
  final TextEditingController? stateController;
  final TextEditingController? countryController;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool enabled;

  const CitySearchField({
    super.key,
    required this.cityController,
    this.stateController,
    this.countryController,
    this.label,
    this.hint,
    this.validator,
    this.enabled = true,
  });

  @override
  State<CitySearchField> createState() => _CitySearchFieldState();
}

class _CitySearchFieldState extends State<CitySearchField> {
  final AuthRepository _authRepository = AuthRepository();
  int? _selectedCityId;

  Future<List<City>> _getSuggestions(String query) async {
    if (query.length < 2) {
      return [];
    }

    try {
      debugPrint('Searching cities for: $query');
      final response = await _authRepository.searchCities(query);
      debugPrint('Received ${response.data.length} cities');
      if (mounted) {
        return response.data;
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching cities: $e');
      // Return empty list on error
      return [];
    }
  }

  Future<void> _onCitySelected(City city) async {
    _selectedCityId = city.id;
    widget.cityController.text = city.name;

    // Fetch city details to get state and country
    if (widget.stateController != null || widget.countryController != null) {
      try {
        debugPrint('Fetching city details for city ID: ${city.id}');
        final details = await _authRepository.getCityDetails(city.id);
        debugPrint('City details: State=${details.data.stateName}, Country=${details.data.countryName}');
        
        if (mounted) {
          setState(() {
            if (widget.stateController != null) {
              widget.stateController!.text = details.data.stateName;
            }
            if (widget.countryController != null) {
              widget.countryController!.text = details.data.countryName;
            }
          });
        }
      } catch (e) {
        debugPrint('Failed to fetch city details: $e');
        // Show error to user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to fetch state and country: ${e.toString()}'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TypeAheadField<City>(
            textFieldConfiguration: TextFieldConfiguration(
              controller: widget.cityController,
              enabled: widget.enabled,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: widget.hint ?? 'Enter city name',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            suggestionsCallback: (pattern) async {
              return await _getSuggestions(pattern);
            },
            itemBuilder: (context, City city) {
              return ListTile(
                title: Text(
                  city.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                dense: true,
              );
            },
            onSuggestionSelected: (City city) {
              _onCitySelected(city);
            },
            animationStart: 0,
            animationDuration: Duration.zero,
            noItemsFoundBuilder: (context) => const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No cities found',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            loadingBuilder: (context) => const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            errorBuilder: (context, error) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error: ${error.toString()}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ),
            hideOnEmpty: false,
            hideOnError: false,
            hideOnLoading: false,
            debounceDuration: const Duration(milliseconds: 500),
            minCharsForSuggestions: 2,
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              borderRadius: BorderRadius.circular(8),
              elevation: 4,
              color: Colors.white,
              constraints: const BoxConstraints(maxHeight: 200),
              hasScrollbar: true,
            ),
            getImmediateSuggestions: false,
            keepSuggestionsOnLoading: true,
            keepSuggestionsOnSuggestionSelected: false,
            direction: AxisDirection.down,
          ),
      ],
    );
  }
}
