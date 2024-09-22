library flutter_corelib;

export 'system/system_global.dart';

// models
export 'system/models/localized_string_type.dart';
export 'system/models/date.dart';
export 'system/models/weekday.dart';
export 'system/models/day_period.dart';
export 'system/models/awaiter.dart';
export 'system/models/expiration.dart';

// cache
export 'system/io/cache_data/cache.dart';
export 'system/io/cache_data/cache_list.dart';
export 'system/io/cache_data/cache_map.dart';
export 'system/io/cache_data/cache_list_map.dart';
export 'system/io/cache_data/date_based_cache_map.dart';

// io
export 'system/io/core/file_location.dart';
export 'system/io/core/file_path.dart';
export 'system/io/core/directory_type.dart';
export 'system/io/spreadsheet/google_spreadsheet.dart';
export 'system/io/spreadsheet/google_spreadsheet_manager.dart';

// shared preference wrapper (unity-style)
export 'system/prefs/playerprefs.dart';
export 'system/prefs/prefs.dart';
export 'system/prefs/prefs_list.dart';
export 'system/prefs/prefs_map.dart';

// utils
export 'system/utils/enum_util.dart';
export 'system/utils/firestore_converter.dart';
export 'system/utils/color_util.dart';
export 'system/utils/uuid_util.dart';

// extensions
export 'system/ext/color_ext.dart';
export 'system/ext/date_time_ext.dart';
export 'system/ext/icon_data_ext.dart';
export 'system/ext/number_ext.dart';
export 'system/ext/string_ext.dart';
export 'system/ext/nullcheck_ext.dart';
export 'system/ext/map_ext.dart';
export 'system/ext/list_ext.dart';
export 'system/ext/weekday_ext.dart';
export 'system/ext/time_of_day_ext.dart';
export 'system/ext/object_ext.dart';

// constants
export 'system/const/color_const.dart';

// database
export 'database/database_mixin.dart';
export 'database/database_model_mixin.dart';
export 'database/database_model.dart';

// view components - common
export 'view/components/common/dot.dart';
export 'view/components/common/cycle_button.dart';
export 'view/components/common/clipped_container.dart';
export 'view/components/common/selectable_container.dart';
export 'view/components/common/dev_note.dart';
export 'view/components/common/labeled.dart';
export 'view/components/common/text_divider.dart';

// widgets - etc
export 'view/components/etc/masked_image.dart';
export 'view/components/etc/page_indicator.dart';
export 'view/components/etc/help_box.dart';
export 'view/components/etc/dot_indicator_filter.dart';
export 'view/components/etc/horizontal_shader_mask.dart';
export 'view/components/etc/outlined_icon.dart';
export 'view/components/etc/halftone_gradient_container.dart';
export 'view/components/etc/search_bar.dart';

// widgets - wrappers
export 'view/components/wrappers/icon_text.dart';
export 'view/components/wrappers/keep_alive_page.dart';
export 'view/components/wrappers/align_padding.dart';
export 'view/components/wrappers/expanded_padding.dart';
export 'view/components/wrappers/stroke_text.dart';
export 'view/components/wrappers/scaled_switch.dart';

// widgets - backgrounds
export 'view/components/backgrounds/animated_diamond_background.dart';
export 'view/components/backgrounds/animated_geometric_background.dart';
export 'view/components/backgrounds/background_pan_direction.dart';
export 'view/components/backgrounds/pattern_background.dart';
export 'view/components/backgrounds/animated_pattern_background.dart';

// widgets - buttons
export 'view/components/buttons/button_entry.dart';
export 'view/components/buttons/expandable_button.dart';
export 'view/components/buttons/image_button.dart';

// widgets - others
export 'view/components/sort_filter/sort_filter.dart';
export 'view/components/clippers/swollen_clipper.dart';
export 'view/components/clippers/diagonal_clipper.dart';
export 'view/components/painters/halftone_gradient_painter.dart';
export 'view/components/painters/pentagon_painter.dart';
export 'view/components/painters/pattern_painter.dart';
export 'view/components/iridescent_color/iridescent_color_controller.dart';
export 'view/components/animated_gradient/animated_gradient_widget.dart';
export 'view/components/timer_widget/timer_widget.dart';

// effects
export 'view/components/effects/halftone_gradient.dart';
export 'view/components/effects/gray_scale.dart';
export 'view/components/effects/grey_scale.dart';
export 'view/components/effects/camera_shake.dart';
export 'view/components/effects/blur_layer.dart';

// slider
export 'view/components/slider/gn_slider.dart';
export 'view/components/slider/slider_thumb.dart';

// vfx
export 'view/components/confetti/confetti.dart';
export 'view/components/confetti/enums/blast_directionality.dart';
export 'view/components/confetti/enums/confetti_controller_state.dart';

// ui framework - core
export 'view/ui_framework/ui_framework.dart';
export 'view/ui_framework/ui_framework_global.dart';
export 'view/ui_framework/toast/toast.dart';
export 'view/ui_framework/transition/transition_utils.dart';
export 'view/ui_framework/transition/tween_direction.dart';

// ui framework - loading
export 'view/ui_framework/loading/loading.dart';
export 'view/ui_framework/loading/loading_controller.dart';
export 'view/ui_framework/loading/ui_loading_widget.dart';

// ui framework - data models
export 'view/ui_framework/models_data/position.dart';
export 'view/ui_framework/models_data/item_entry.dart';
export 'view/ui_framework/models_data/item_picker_item.dart';

// ui framework - enum models
export 'view/ui_framework/models_enum/container_order.dart';
export 'view/ui_framework/models_enum/widget_display_option.dart';
export 'view/ui_framework/models_enum/widget_direction.dart';
export 'view/ui_framework/models_enum/ui_size.dart';
export 'view/ui_framework/models_enum/border_direction.dart';
export 'view/ui_framework/models_enum/overflow_behaviour.dart';

// ui framework - utility models
export 'view/ui_framework/models_utility/responsive.dart';
export 'view/ui_framework/models_utility/simple_sprite_animation.dart';

// ui framework - inner widget
export 'view/ui_framework/inner_widget/inner_widget_mixin.dart';
export 'view/ui_framework/inner_widget/stateless_inner_widget.dart';
export 'view/ui_framework/inner_widget/stateful_inner_widget.dart';

// ui framework - easy components
export 'view/ui_framework/easy_components/easy_scaffold.dart';
export 'view/ui_framework/easy_components/easy_container.dart';
export 'view/ui_framework/easy_components/easy_button.dart';
export 'view/ui_framework/easy_components/easy_checkbox.dart';

// ui framework - extenstions
export 'view/ui_framework/view_ext/border_ext.dart';
export 'view/ui_framework/view_ext/border_radius_ext.dart';
export 'view/ui_framework/view_ext/border_direction_ext.dart';
export 'view/ui_framework/view_ext/text_align_ext.dart';

// ui framework - information button
export 'view/ui_framework/info_button/info_button.dart';
export 'view/ui_framework/info_button/info_message.dart';

// ui framework - dialog
export 'view/ui_framework/my_dialog/my_dialog.dart';

export 'view/ui_framework/my_dialog/models_dialog_viewbase/popup_material.dart';
export 'view/ui_framework/my_dialog/models_dialog_viewbase/popup_container.dart';

export 'view/ui_framework/my_dialog/models_components/base_dialog_close_button.dart';
export 'view/ui_framework/my_dialog/models_components/my_dialog_close_button.dart';

export 'view/ui_framework/my_dialog/models_utility/dialog_action.dart';
export 'view/ui_framework/my_dialog/models_utility/dialog_message.dart';
export 'view/ui_framework/my_dialog/models_utility/close_dialog_callback.dart';

// ui framework - color library
export 'view/ui_framework/models_enum/ui_color.dart';
export 'view/ui_framework/color_library/routina_colors.dart';

// network
export 'network/models/result.dart';
export 'network/models/string_or.dart';
export 'network/models/unix_time.dart';
export 'network/client/json_http_converter.dart';
export 'network/client/log_settings.dart';
export 'network/client/client_settings.dart';
export 'network/client/http_method.dart';
export 'network/client/dio_logging_intercepter.dart';
export 'network/client/http_request_timer.dart';
export 'network/services/object_provider.dart';
export 'network/crud/base_crud_controller.dart';
export 'network/crud/crud_models.dart';

// external libraries
export 'package:get/get.dart' hide Condition, Response, FormData, MultipartFile;
export 'package:intl/intl.dart';
export 'package:auto_size_text/auto_size_text.dart';
export 'package:logging/logging.dart';
export 'package:path_provider/path_provider.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:syncfusion_flutter_calendar/calendar.dart';
export 'package:animated_text_kit/animated_text_kit.dart';
export 'package:googleapis/drive/v3.dart';
export 'package:csv/csv.dart';
export 'package:scratcher/scratcher.dart';
export 'package:freezed_annotation/freezed_annotation.dart';
export 'package:path/path.dart' show join;
export 'package:hive/hive.dart';
//export 'package:uuid/uuid.dart';
