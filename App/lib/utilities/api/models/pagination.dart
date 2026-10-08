class Pagination {
  int position;
  int limit;

  Pagination(this.position, this.limit);

  Map<String, dynamic> serialize() {
    return {
      "position": position.toString(),
      "limit": limit.toString()
    };
  }
}