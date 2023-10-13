import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FetchSelect extends ConsumerStatefulWidget {
  const FetchSelect({
    super.key,
    required this.fetchFor,
    required this.elementIdKey,
    required this.elementDisplayKey,
    this.elementSubtitleKey,
    required this.asyncItemsFetch,
    required this.onChanged,
  });

  final String fetchFor;

  final String elementIdKey;
  final String elementDisplayKey;
  final String? elementSubtitleKey;
  final Future<List<dynamic>> Function(String filter) asyncItemsFetch;
  final Function(dynamic value) onChanged;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FetchSelectState();
}

class _FetchSelectState extends ConsumerState<FetchSelect> {
  final TextEditingController elementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<dynamic>(
      dropdownBuilder: (context, selectedItem) {
        if (selectedItem == null) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              // color: Colors.white,
            ),
            child: Row(
              children: [
                const Icon(Icons.search),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Select ${widget.fetchFor}',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // color: Colors.white,
          ),
          child: Row(
            children: [
              Icon(Icons.account_circle, color: Colors.grey.shade600),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.elementDisplayKey == '_name'
                      ? selectedItem['_name']['value']
                      : selectedItem[widget.elementDisplayKey],
                ),
              ),
            ],
          ),
        );
      },
      compareFn: (element, selectedElement) {
        return element?[widget.elementIdKey] ==
            selectedElement?[widget.elementIdKey];
      },
      popupProps: PopupProps.modalBottomSheet(
        containerBuilder: (context, popupWidget) {
          return Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  // padding: EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    '${widget.fetchFor}s',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              const Divider(
                thickness: 1,
              ),
              Flexible(
                child: Container(
                  color: Colors.white,
                  child: popupWidget,
                ),
              ),
            ],
          );
        },
        modalBottomSheetProps: const ModalBottomSheetProps(
          elevation: 0,
          useSafeArea: true,
          padding: EdgeInsets.all(18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
        ),
        showSearchBox: true,
        showSelectedItems: true,
        isFilterOnline: true,
        // searchDelay: const Duration(milliseconds: 700),
        emptyBuilder: (context, searchEntry) {
          if (searchEntry == '') {
            return Container(
                alignment: Alignment.topCenter,
                child: Text(
                  'Search to see ${widget.fetchFor}s',
                  style: TextStyle(color: Colors.grey.shade600),
                ));
          }
          return Container(
              alignment: Alignment.topCenter,
              child: Text(
                '${widget.fetchFor} $searchEntry not Found',
                style: TextStyle(color: Colors.grey.shade600),
              ));
        },
        searchDelay: const Duration(seconds: 1),
        searchFieldProps: TextFieldProps(
          // controller: elementController,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.grey.shade400),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            fillColor: Colors.grey.shade900,
            labelText: 'Search',
            isDense: true,
            contentPadding: const EdgeInsets.all(12),
            prefixIcon: const Icon(Icons.search),
            prefixIconColor: Colors.grey,
          ),
        ),
        itemBuilder: (context, element, isSelected) {
          // print(item);
          // print(item.customer_display_name);
          return ListTile(
            title: Text(
              widget.elementDisplayKey == '_name'
                  ? element['_name']['value']
                  : element[widget.elementDisplayKey],
            ),
            subtitle: widget.elementSubtitleKey ??
                (element[widget.elementSubtitleKey]),
            trailing:
                isSelected ? const Icon(Icons.check) : const SizedBox(width: 0),
          );
        },
      ),
      asyncItems: (String filter) async {
        if (filter == '') {
          return [];
        }
        dynamic searchedItems = await widget.asyncItemsFetch(filter);
        return searchedItems;
        // return await widget.asyncItemsFetch(filter);
      },
      onChanged: (value) {
        widget.onChanged(value);
      },
    );
  }
}
