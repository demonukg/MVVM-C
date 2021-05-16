import RxSwift

final class ProfileViewDataComposer {

  func makeViewDataArray(with profile: Profile) -> [ConfigurableViewData] {
    let viewTypes: [ViewType] = [
      .spacer(Layout.Spacing.medium),
      .keyValue(key: "Name", value: profile.name),
      .spacer(Layout.Spacing.small),
      .keyValue(key: "Nickname", value: profile.nickname),
      .spacer(Layout.Spacing.small),
      .keyValue(key: "Phone", value: profile.phoneNumber),
      .spacer(Layout.Spacing.medium),
    ]
    let viewDataList = viewTypes.map { type in
      makeViewData(with: type)
    }
    return viewDataList
  }
}

private extension ProfileViewDataComposer {

  indirect enum ViewType {

    case spacer(_ height: CGFloat)
    case keyValue(key: String, value: String)
  }

  func makeViewData(with viewType: ViewType) -> ConfigurableViewData {
    switch viewType {
    case .spacer(let height):
      return VerticalSpacerView.ViewData(height: height)
    case let .keyValue(key, value):
      return KeyValueView.ViewData(keyText: key, valueText: value)
    }
  }
}
