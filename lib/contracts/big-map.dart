class BigMapAbstraction {
  BigInt id;
  BigMapAbstraction(BigInt id) {
    this.id = id;
  }

  toJSON() {
    return this.id.toString();
  }

  toString() {
    return this.id.toString();
  }
}
