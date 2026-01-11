class VaccineListRequest {
  final int? page;
  final int? size;
  final String? filter;
  final String? sort;

  VaccineListRequest({
    this.page = 1,
    this.size = 12,
    this.filter,
    this.sort,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{
      'page': page.toString(),
      'size': size.toString(),
    };
    if (filter != null && filter!.isNotEmpty) {
      params['filter'] = filter;
    }
    if (sort != null && sort!.isNotEmpty) {
      params['sort'] = sort;
    }
    return params;
  }
}
