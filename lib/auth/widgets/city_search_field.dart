import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/models/api_models.dart';

class CitySearchField extends StatefulWidget {
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController countryController;

  const CitySearchField({
    super.key,
    required this.cityController,
    required this.stateController,
    required this.countryController,
  });

  @override
  State<CitySearchField> createState() => _CitySearchFieldState();
}

class _CitySearchFieldState extends State<CitySearchField> {
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;

  Future<List<City>> _getCitySuggestions(String query) async {
    if (query.length < 2) return [];
    
    try {
      final response = await _authRepository.searchCities(query);
      return response.data;
    } catch (e) {
      debugPrint('Error fetching cities: $e');
      return [];
    }
  }

  Future<void> _onCitySelected(City city) async {
    widget.cityController.text = city.name;
    
    try {
      setState(() => _isLoading = true);
      final details = await _authRepository.getCityDetails(city.id);
      
      if (mounted) {
        setState(() {
          widget.stateController.text = details.data.stateName;
          widget.countryController.text = details.data.countryName;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching city details: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch city details: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TypeAheadField<City>(
        controller: widget.cityController,
        builder: (context, controller, focusNode) {
          return TextField(
            controller: controller,
            focusNode: focusNode,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'City',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              suffixIcon: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
            ),
          );
        },
        suggestionsCallback: _getCitySuggestions,
        itemBuilder: (context, City city) {
          return ListTile(
            title: Text(city.name),
            dense: true,
          );
        },
        onSelected: _onCitySelected,
        hideOnEmpty: false,
        hideOnLoading: false,
        loadingBuilder: (context) => const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
        emptyBuilder: (context) => const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No cities found'),
        ),
        errorBuilder: (context, error) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }
}

