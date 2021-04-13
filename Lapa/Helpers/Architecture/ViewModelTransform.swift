protocol ViewModelTransform {

  associatedtype Input
  associatedtype Output

  func transform(input: Input) -> Output
}
